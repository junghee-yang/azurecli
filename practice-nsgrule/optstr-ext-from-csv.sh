#!/bin/bash
# Created by : Junghee Yang(junghee.yang@quest-global.com)
# Date : 30-Dec-2020
# Note : parsing a csv file passed as parameter and command.
#        if third parameter is passed, only matched field
#        with those parameter is 
#        execute command with parsed arguments from csv file
#        this script are written to reusage of csv file used 
#        to create resource for deleting resource.
# ----------------------------------------------------------
source check-status.sh

INPUT=$1
CMD=$2
CHECKOPT=($3)

(( ENABLE_CHECKOPT = ${#CHECKOPT[@]}>0?1:0 ))
OLDIFS=$IFS
IFS=','

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 1; }

export ref=()
if [ $ENABLE_CHECKOPT -eq 1 ] ; then
    # find specific string in head row of csv file
    # "head -n 1 'csv file'"   : read first row from csv file
    # 'tr -s "," "\n"'         : replace ',' to '\n'
    # grep -n 'match string'   : return line no where 'match string' is founded
    # cut -d ":" -f 1          : delimenator is ":" and cut it then retrun column 1
    headData=$(head -n 1 $INPUT | tr -s "," "\n")
    refIdx=0
    
    for idx in ${!CHECKOPT[@]}; do
        # grep returns line number, so it needs to substract 1 from the result value.
        extractIdx=$(echo $headData | grep -n "^${CHECKOPT[$idx]}\b" | cut -d ":" -f 1)
        (( extractIdx-- ))
        ref[$refIdx]=$extractIdx
        
        (( refIdx++ ))
    done
else
    # read head data of cvs file to an array with deliiter ","
    IFS=", "  read -r -a columns <<< "$(head -n 1 $INPUT)"
    for (( idx=0; idx<=${#columns[@]}; idx++ )); do
        ref[$idx]=$idx
        # remove CR character
        dataRMCR=${columns[$idx]//[$'\r']}
        CHECKOPT[$idx]=$dataRMCR
    done
fi

# read data from $INPUT file except the first line
while IFS= read -ra line || [ -n "$line" ]; do
    # read data to an array with delimiter ",".
    IFS=", " read -r -a columns <<< "$line"
    export optStr=""
    colIdx=0
    # check value using refIdx found
    for idx in ${ref[@]}; do
        # check null of ${columns[$idx]}
        colValue=${columns[$idx]}

        # remove carriage return chracter
        # in case of the last column of a row have cr
        
        value=$(echo ${colValue//[$'\r']} | xargs)
	value=$colValue
	if [ ! -z $value ]; then
            optStr="$optStr --${CHECKOPT[$colIdx]} $value"
            (( colIdx++ ))
        fi
    done

    if [ -n $optStr ]; then
        eval $CMD $optStr
        status=$(check_status)
        if [ $status == "fail" ]; then
            echo "Fail to execute $CMD $optStr"
            IFS=$OLDIFS
            exit 1
        else
            echo "Succeed to execute $CMD $optStr"
        fi

    fi
done <<< $(tail -n +2 $INPUT)

IFS=$OLDIFS
exit 0

#!/bin/bash
# Purpose: Read Comma Separated CSV File
# Author: Vivek Gite under GPL v2.0+
# Modified by : Junghee Yang(junghee.yang@quest-global.com)
# Date : 28-Dec-2020
# Note : parsing a csv file passed as parameter and command.
#        execute command with parsed arguments from csv file
# ----------------------------------------------------------

source check-status.sh

INPUT=$1
CMD=$2

OLDIFS=$IFS
IFS=','

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 1; }

lineNo=0
options=()

while IFS= read -ra line || [ -n "$line" ]
do
    optStr=""
    colIndex=0

    IFS=", "  read -r -a columns <<< "$line"

    colNo=${#columns[@]}

    for coIndex in "${!columns[@]}"
    do
        colValue=${columns[$colIndex]}
        colValue=$(echo ${colValue//[$'\r']} | xargs)
        if [ $lineNo -eq 0 ]; then
            options[$coIndex]=${colValue}
        elif [[ ! -z $colValue && -n $colValue && colIndex -gt 0 ]]; then
            optStr="$optStr --${options[$colIndex]} $colValue"
        elif [[ -n $colValue && $colIndex -eq 0 ]]; then
            optStr="$optStr --name $colValue"
        else
            echo "$$$$ nothing to do"
        fi

        ((colIndex++))
    done


       
    if [[ $colNo -eq $colIndex && -n $optStr ]]; then
        eval $CMD "$optStr"
        status=$(check_status)
        if [ $status == "fail" ]; then
            echo "\nFail to execute $CMD $optStr\n"
            exit 1
        else
            echo "\nSucceed to execute $CMD $optStr\n"
        fi
    fi

   ((lineNo++))
done < $INPUT

IFS=$OLDIFS
exit 0

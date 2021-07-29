#!/bin/bash
# Purpose : Create a group of Azure active directory
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 22-July-2021
#--------------------------------------------------------------------------
source check-status.sh
exec_shell="sh optstr-group-from-csv.sh"

MEMBER_FILE=$1
DISPLAY_NAME=$2
NICK_NAME=$3

if [[ -z $NICK_NAME ]]; then
    NICK_NAME=$2
fi

az ad group create --display-name $DISPLAY_NAME --mail-nickname $NICK_NAME

output=$($exec_shell $MEMBER_FILE "az ad group member add --group $DISPLAY_NAME")
[[ $(check_status) == "fail" ]] && { eval "az ad group delete --group $DISPLAY_NAME"; exit 1;}
echo $output



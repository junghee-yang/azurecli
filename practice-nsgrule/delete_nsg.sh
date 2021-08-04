#!/bin/bash
# Purpose : delete nsg
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 27-July-2021
#-------------------------------------------------------------------------
exec_shell=". optstr-ext-from-csv.sh"

source check-status.sh

#delete resource group
#output=$($exec_shell "rg.csv" "az group delete")
#[[ $(check_status) == "fail" ]] && { echo "Fail to delete resource group"; exit 1; }
#echo $output

#create nsg rule
output=$($exec_shell "nsgrule.csv" "az network nsg rule delete" "name resource-group nsg-name")
[[ $(check_status) == "fail" ]] && { echo "Fail to delete network security rule"; exit 1; }
echo $output


#delete nsg
output=$($exec_shell "nsg.csv" "az network nsg delete" "name resource-group")
[[ $(check_status) == "fail" ]] && { echo "Fail to delete network security group"; exit 1; }
echo $output




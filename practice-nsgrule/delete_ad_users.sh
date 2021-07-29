#!/bin/bash
# Purpose : Add new user of Azure active directory as refer to a csv file
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 22-July-2021
#--------------------------------------------------------------------------

exec_shell="sh optstr-ext-from-csv.sh"

output=$($exec_shell "adusers-del.csv" "az ad user delete")
echo $output



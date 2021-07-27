#!/bin/bash
# Purpose : Add new user of Azure active directory as refer to a csv file
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 22-July-2021
#--------------------------------------------------------------------------

exec_shell="sh optstr-from-csv.sh"

output=$($exec_shell "adusers.csv" "az ad user create")
echo $output



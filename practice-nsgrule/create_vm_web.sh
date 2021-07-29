# !/bin/bash
# Purpose : create nsg
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 27-July-2021
#-------------------------------------------------------------------------
source check-status.sh
exec_shell="sh optstr-from-csv.sh"

#create resource group
output=$($exec_shell "rg.csv" "az group create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create resource group"; exit 1; }
echo $output

#create vnet
output=$($exec_shell "vnet.csv" "az network vnet create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create vnet"; exit 1; }
echo $output

#create subnet
output=$($exec_shell "vnet.csv" "az network vnet subnet create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create subnet"; exit 1; }
echo $output

#create nic
output=$($exec_shell "nic.csv" "az network nic create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create nic"; exit 1; }
echo $output

#create vm
#output=$($exec_shell "vm.csv" "az vnet create")
#[[ $(check_status) == "fail" ]] && { echo "Fail to create nic"; exit 1; }
#echo $output

#create nsg
#output=$($exec_shell "nsg.csv" "az network nsg create")
#[[ $(check_status) == "fail" ]] && { echo "Fail to create network security group"; exit 1; }
#echo $output

#create nsg rule
#output=$($exec_shell "nsgrule.csv" "az network nsg rule create")
#[[ $(check_status) == "fail" ]] && { echo "Fail to create network security rule"; exit 1; }
#echo $output


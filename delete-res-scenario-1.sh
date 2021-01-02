# !/bin/bash
# Purpose: delete resources as refer to a csv file.
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 31-Dec-2020
# -------------------------------------------------------
exec_shell="sh optstr-ext-from-csv.sh"

# Delete VM resource
output=$($exec_shell "csvFiles/vm-2.csv" "az vm delete -y" "name resource-group")
echo $output

# Delete NIC
output=$($exec_shell "csvFiles/nic.csv" "az network nic delete" "name resource-group")
echo $output

# Delete Subnet resource
output=$($exec_shell "csvFiles/subnet.csv" "az network vnet subnet delete" "name resource-group vnet-name")
echo $output

# Delete NSG resource
output=$($exec_shell "csvFiles/nsg.csv" "az network nsg delete" "name resource-group")
echo $output

# Delete NSG rule
# output=$($exec_shell "csvFiles/nsgrule.csv" "az network nsg rule delete" "name resource-group nsg-name")
# echo $output

# Delete VNet resource
output=$($exec_shell "csvFiles/vnet.csv" "az network vnet delete" "name resource-group")
echo $output

# Delete Resource group
#output=$($exec_shell "csvFiles/rg.csv" "az group delete -y" "name")
#echo $output

sh delete-unused-res.sh


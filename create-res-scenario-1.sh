
# !/bin/bash
# Purpose: create resources as refer to a csv file.
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 28-Dec-2020
# -------------------------------------------------------
exec_shell="sh optstr-from-csv.sh"

# Create Resource group
output=$($exec_shell "csvFiles/rg.csv" "az group create")
echo $output

# Create NSG resource
output=$($exec_shell "csvFiles/nsg.csv" "az network nsg create")
echo $output

# Create NSG rule
output=$($exec_shell "csvFiles/nsgrule.csv" "az network nsg rule create")

# Create VNet resource
output=$($exec_shell "csvFiles/vnet.csv" "az network vnet create") 
echo $output

# Create Subnet resource
output=$($exec_shell "csvFiles/subnet.csv" "az network vnet subnet create")
echo $output

# Create VM resource
output=$($exec_shell "csvFiles/vm-2.csv" "az vm create")
echo $output


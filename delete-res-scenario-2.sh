# !/bin/bash
# Purpose: delete resources as refer to a csv file.
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 6-Jan-2020
# -------------------------------------------------------
exec_shell="sh optstr-ext-from-csv.sh"

echo "---------------------- Start [Delete VM] -----------------------------"
# Delete VM resource
echo $($exec_shell "csvFiles/vm-3.csv" "az vm delete -y" "name resource-group")
echo "----------------------- End [Delete VM] ------------------------------"

echo "---------------------- Start [Delete IP Config]-----------------------"
echo $($exec_shell "csvFiles/nic-ipconfig.csv" "az network nic ip-config delete" "name resource-group nic-name")
echo "------------------------ End [Delete IP Config]-----------------------"

echo "---------------------- Start [Delete NIC] ----------------------------"
echo $($exec_shell "csvFiles/nic.csv" "az network nic delete" "name resource-group")
echo "------------------------ End [Delete NIC] ----------------------------"

echo "---------------------- Start [Delete LB] -----------------------------"
echo $($exec_shell "csvFiles/lb.csv" "az network lb delete" "name resource-group")
echo "------------------------ End [Delete LB] -----------------------------"

echo "------------------- Start [Delete Public IP] -------------------------"
echo $($exec_shell "csvFiles/pip.csv" "az network public-ip delete" "name resource-group")
echo "-------------------- End [Delete Public IP] --------------------------"

echo "--------------------- Start [Delete Subnet] --------------------------"
echo $($exec_shell "csvFiles/subnet.csv" "az network vnet subnet delete" "name resource-group vnet-name")
echo "---------------------- End [Delete Subnet] ---------------------------"

echo "----------------------- Start [Delete NSG] ---------------------------"
echo $($exec_shell "csvFiles/nsg.csv" "az network nsg delete" "name resource-group")
echo "------------------------ End [Delete NSG] ----------------------------"

echo "----------------- Start [Delete Availability Set] --------------------"
echo $($exec_shell "csvFiles/avail.csv" "az vm availability-set delete" "name resource-group")
echo "------------------ End [Delete Availability Set] ---------------------"

echo "----------------------- Start [Delete VNet] --------------------------"
echo $($exec_shell "csvFiles/vnet.csv" "az network vnet delete" "name resource-group")
echo "------------------------ End [Delete VNet] ---------------------------"

sh delete-unused-res.sh

echo "----------------- Start [Delete Resource Group] ----------------------"
echo $($exec_shell "csvFiles/rg.csv" "az group delete" "name")
echo "----------------- End  [Delete Resource Group] -----------------------"

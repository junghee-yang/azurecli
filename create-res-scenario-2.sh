
# !/bin/bash
# Purpose: create resources as refer to a csv file.
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 5-Jan-2021
# -------------------------------------------------------
source check-status.sh
exec_shell="sh optstr-from-csv.sh"

# Create Resource group
echo "--------------- Start [Create Resource Group] -----------------"
output=$($exec_shell "csvFiles/rg.csv" "az group create")
status=$(check_status)
if [ status == "fail" ]; then
    echo "Fail to create resource group"
    exit 1
else
    echo $output
fi
echo "----------------- End [Create Resource Group] -----------------"

echo "-------------------- Start [Create VNet]  ---------------------"
# Create VNet resource
output=$($exec_shell "csvFiles/vnet.csv" "az network vnet create") 
echo $output
echo "-------------------- End [Create VNet]  -----------------------"

echo "--------------- Start [Create Availability Set] ---------------"
# Create Avaliability Set
output=$($exec_shell "csvFiles/avail.csv" "az vm availability-set create")
echo $output
echo "---------------- End [Create Availability Set] ----------------"

echo "-------------------- Start [Create NSG] -----------------------"
# Create NSG resource
output=$($exec_shell "csvFiles/nsg.csv" "az network nsg create")
echo $output
echo "-------------------- End [Create NSG] -------------------------"

echo "-------------------- Start [Create Subnet] --------------------"
# Create Subnet resource
output=$($exec_shell "csvFiles/subnet.csv" "az network vnet subnet create")
echo $output
echo "---------------------- End [Create Subnet] --------------------"

echo "--------------- Start [Create Public IP] ----------------------"
#Create PIP resource
output=$($exec_shell "csvFiles/pip.csv" "az network public-ip create")
echo $output
echo "----------------- End [Create Public IP] ----------------------"

echo "--------------- Start [Create Load Balancer] ------------------"
#Create Load Balancer
output=$($exec_shell "csvFiles/lb.csv" "az network lb create")
echo $output
echo "----------------- End [Create Load Balancer] ------------------"

echo "----------------- Start [Create Probe] ------------------------"
#Create Probe of Load Balancer
output=$($exec_shell "csvFiles/probe.csv" "az network lb probe create")
echo $output
echo "----------------- End [Create Probe] --------------------------"

echo "--------------- Start [Create LB rule] ------------------------"
#Create Rule of Load Balancer
output=$($exec_shell "csvFiles/lbrule.csv" "az network lb rule create")
echo $output
echo "----------------- End [Create LB rule] ------------------------"

echo "------------------ Start [Create NIC] -------------------------"
#Create Network Interface
output=$($exec_shell "csvFiles/nic.csv" "az network nic create")
echo $output
echo "-------------------- End [Create NIC] -------------------------"

echo "------------ Start [Create NIC IP-config] ---------------------"
#Create NIC IP config
output=$($exec_shell "csvFiles/nic-ipconfig.csv" "az network nic ip-config create")
echo "------------- End [Create NIC IP-config] ----------------------"

echo "------------------- Start [Create VM] -------------------------"
#Create VM
output=$($exec_shell "csvFiles/vm-3.csv" "az vm create --ssh-key-values '$(cat /Users/msprodo/.ssh/id_rsa.pub)'")
echo $output
echo "-------------------- End [Create VM] --------------------------"

# Create NSG rule
#output=$($exec_shell "csvFiles/nsgrule.csv" "az network nsg rule create")
#echo $output

# Create VM resource
#output=$($exec_shell "csvFiles/vm-2.csv" "az vm create")
#echo $output


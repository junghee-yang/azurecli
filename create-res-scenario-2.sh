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
[[ $(check_status) == "fail" ]] && { echo "Fail to create resource group"; exit 1; }
echo $output
echo "----------------- End [Create Resource Group] -----------------"

echo "-------------------- Start [Create VNet]  ---------------------"
# Create VNet resource
output=$($exec_shell "csvFiles/vnet.csv" "az network vnet create") 
[[ $(check_status) == "fail" ]] && { echo "Fail to create vnet"; exit 1; }
echo $output
echo "-------------------- End [Create VNet]  -----------------------"

echo "--------------- Start [Create Availability Set] ---------------"
# Create Avaliability Set
output=$($exec_shell "csvFiles/avail.csv" "az vm availability-set create")
[[ $(check_status) == "fail" ]] && { echo "Fail to Availability set"; exit 1; }
echo $output
echo "---------------- End [Create Availability Set] ----------------"

echo "-------------------- Start [Create NSG] -----------------------"
# Create NSG resource
output=$($exec_shell "csvFiles/nsg.csv" "az network nsg create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create nsg"; exit 1; }
echo $output
echo "-------------------- End [Create NSG] -------------------------"

echo "-------------------- Start [Create NSG Rule] -------------------------"
# Create NSG rule resource
output=$($exec_shell "csvFiles/nsgrule.csv" "az network nsg rule create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create nsg rule"; exit 1; }
echo $output
echo "-------------------- End [Create NSG Rule] -------------------------"

echo "-------------------- Start [Create Subnet] --------------------"
# Create Subnet resource
output=$($exec_shell "csvFiles/subnet.csv" "az network vnet subnet create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create subnet"; exit 1; }
echo $output
echo "---------------------- End [Create Subnet] --------------------"

echo "--------------- Start [Create Public IP] ----------------------"
#Create PIP resource
output=$($exec_shell "csvFiles/pip.csv" "az network public-ip create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create public-ip"; exit 1; }
echo $output
echo "----------------- End [Create Public IP] ----------------------"

echo "--------------- Start [Create Load Balancer] ------------------"
#Create Load Balancer
output=$($exec_shell "csvFiles/lb.csv" "az network lb create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create load balancer"; exit 1; }
echo $output
echo "----------------- End [Create Load Balancer] ------------------"

echo "----------------- Start [Create Probe] ------------------------"
#Create Probe of Load Balancer
output=$($exec_shell "csvFiles/probe.csv" "az network lb probe create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create load balancer probe"; exit 1; }
echo $output
echo "----------------- End [Create Probe] --------------------------"

echo "--------------- Start [Create LB rule] ------------------------"
#Create Rule of Load Balancer
output=$($exec_shell "csvFiles/lbrule.csv" "az network lb rule create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create load balancer rule"; exit 1; }
echo $output
echo "----------------- End [Create LB rule] ------------------------"

echo "------------------ Start [Create NIC] -------------------------"
#Create Network Interface
output=$($exec_shell "csvFiles/nic.csv" "az network nic create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create NIC"; exit 1; }
echo $output
echo "-------------------- End [Create NIC] -------------------------"

echo "------------ Start [Create NIC IP-config] ---------------------"
#Create NIC IP config
output=$($exec_shell "csvFiles/nic-ipconfig.csv" "az network nic ip-config create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create nic ip-config"; exit 1; }
echo $output
echo "------------- End [Create NIC IP-config] ----------------------"

echo "------------------- Start [Create VM] -------------------------"
#Create VM
# linux vm
#output=$($exec_shell "csvFiles/vm-3.csv" "az vm create --ssh-key-values '$(cat /Users/msprodo/.ssh/id_rsa.pub)'")
# windows vm doesn't support ssh-key
output=$($exec_shell "csvFiles/vm-3.csv" "az vm create")
[[ $(check_status) == "fail" ]] && { echo "Fail to create VMs"; exit 1; }
echo $output
echo "-------------------- End [Create VM] --------------------------"

#echo "-------------- Start [Create Log Workspace] -------------------"
#MYLOGWS="mylog-workspace"
#MYLOGWS_LOCATION="eastus"
#az group create -l $MYLOGWS_LOCATION -n $MYLOGWS
#az deployment group create --resource-group $MYLOGWS --name <my-deployment-name> --template-file deploylaworkspacetemplate.json

#echo "--------------- End [Create Log Workspace] --------------------"

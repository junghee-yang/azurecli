# !/bin/bash
# Purpose: find and delete unused resources.
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 31-Dec-2020
# -----------------------------------------------------------------------------
# find unused disk
unattachedDiskIds=$(az disk list --query '[?managedBy==`null`].[id]' -o tsv)
for id in ${unattachedDiskIds[@]}
do
   echo "Deleting unattached Managed Disk with Id: "$id
   az disk delete --ids $id --yes 
   echo "Deleted unattached Managed Disk with Id: "$id
done

# find unused NSG
unusedNSG=$(az network nsg list --query '[?subnet==null && networkInterfaces==null].[id]' -o tsv)
for id in ${unusedNSG[@]}
do
    echo "Deleting unused NSG with Id : "$id
    az network nsg delete --ids $id
    echo "Deleted unused NSG with Id : "$id
done

# find unused Public IP
unusedIP=$(az network public-ip list --query '[?ipAddress==null].[id]' -o tsv)
for id in ${unusedIP[@]}
do
    echo "Deleting unused Public IP with Id : "$id
    az network public-ip delete --ids $id
    echo "Deleted unused Public IP with Id : "$id
done


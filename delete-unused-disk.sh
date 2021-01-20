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

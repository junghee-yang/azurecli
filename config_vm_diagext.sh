# !/bin/bash
# Purpose : create storage account for diagnostic extension
            config vm to set diagnositcs
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 20-Jan-2021
#--------------------------------------------------------------------------
RANDOM=1

# Set the following 3 parameters first.
my_resource_group=$1
my_windows_vm=$2

my_diagnostic_storage_account=diagprj2storage$RANDOM
echo $my_diagnostic_storage_account

[[ -z $1 || -z $2 ]] && { echo "Invalid empty argument"; exit 1; }

# create storage account for diag
echo ">>>>>> try to create storage account for diagnostics"
az storage account create -g dev-prj2-koreacentral -n $my_diagnostic_storage_account

# windows vm id
my_vm_resource_id=$(az vm show -g $my_resource_group -n $my_windows_vm --query "id" -o tsv)

default_config=$(az vm diagnostics get-default-config  --is-windows-os \
    | sed "s#__DIAGNOSTIC_STORAGE_ACCOUNT__#$my_diagnostic_storage_account#g" \
    | sed "s#__VM_OR_VMSS_RESOURCE_ID__#$my_vm_resource_id#g")

# Please use the same options, the WAD diagnostic extension has strict
# expectations of the sas token's format. Set the expiry as desired.
storage_sastoken=$(az storage account generate-sas \
    --account-name $my_diagnostic_storage_account --expiry 2037-12-31T23:59:00Z \
    --permissions acuw --resource-types co --services bt --https-only --output tsv)

protected_settings="{'storageAccountName': '$my_diagnostic_storage_account', \
		    'storageAccountSasToken': '$storage_sastoken'}"

az vm diagnostics set --settings "$default_config" \
    --protected-settings "$protected_settings" \
    --resource-group $my_resource_group --vm-name $my_windows_vm

# # Alternatively, if the WAD extension has issues parsing the sas token,
# # one can use a storage account key instead.
storage_account_key=$(az storage account keys list --account-name {my_diagnostic_storage_account} \
  --query [0].value -o tsv)
protected_settings="{'storageAccountName': '$my_diagnostic_storage_account', \
  'storageAccountKey': '$storage_account_key'}"


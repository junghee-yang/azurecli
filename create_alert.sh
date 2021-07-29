# !/bin/bash
# Purpose : create alerts for vm created
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 19-Jan-2021
#--------------------------------------------------------------------------
source check-status.sh
exec_shell="sh optstr-from-csv.sh"

Template_Path="/Users/msprodo/study/ARMTemplate/AzureMonitorForVMs-ArmTemplates-4.0.0/OnbordingTemplates"
WSConfigure_Template=$Template_Path"/ConfigureWorkspace/ConfigureWorkspaceTemplate.json"
#OnboardVM_Template=$Template_Path"/ExistingVmOnboarding/ExistingVmOnboardingTemplate.json"
OnboardVM_Template="./template/ExistingVmOnboardingTemplate.json"
Ref_vmcsv="csvFiles/vm-3.csv"

# create workspace of log analytics with a template file
#echo "----------- Start [Create Log analytics workspace] --------------"
#output=$($exec_shell "csvFiles/logws.csv" "az deployment group create")
#[[ $(check_status) == "fail" ]] && { echo "Fail to create log analaytics ws"; exit 1; }
#echo $(echo $output | grep workspaceName)
#echo "------------ End [Create Log analytics workspace] ---------------"

OLD_IFS=$IFS
IFS=", " read -r -a columns <<<"$(tail -n +2 'csvFiles/logws.csv')"
echo "${columns[0]}   ---- ${columns[1]} === $(echo ${columns[2]} | cut -d '=' -f 2) "
WSName=$(echo ${columns[2]} | cut -d '=' -f 2)
WSRSGroup=${columns[0]}

IFS=$OLD_IFS

# configure workspace
#echo "----------- Start [Configure workspace for VMInsight] -----------"
WSInfo=($(az monitor log-analytics workspace list -o tsv --query "[?name=='$WSName'].[id,location]"))
echo " ${WSInfo[0]} ${WSInfo[1]} "
WSId=${WSInfo[0]}
WSLoc=${WSInfo[1]}

#az deployment group create -g dev-prj2-koreacentral --template-file $WSConfigure_Template --parameters WorkspaceResourceId=$WSId WorkspaceLocation=$WSLoc
#echo "------------ End [Configure workspace for VMInsight] ------------"


#echo "------------------- Start [Onboarding VM] -----------------------"
# get vm names created
VmNames=($(tail +2 $Ref_vmcsv | cut -d ',' -f 1 | tr -s '\n' ' '))
#idx=0
for vmname in ${VmNames[@]}; do
    info=($(az vm list -o tsv --query "[?name=='$vmname'].[id, location, storageProfile.osDisk.osType, resourceGroup]"))
    RSGroup=${info[3]}
#    az deployment group create -n $vmname"-deploy-$idx" -g ${info[3]} --template-file $OnboardVM_Template --parameters VmResourceId=${info[0]} VmLocation=${info[1]} osType=Windows WorkspaceResourceId=$WSId
#    (( index++ ))
done
#echo "-------------------- End [Onboarding VM] ------------------------"

#echo "---------------- Start [Create Action Group] --------------------"
#DeployName_ag="ag-dev-prj2"
#ActionGroup_template="./template/actiongroup.json"
ActionGroup_name="prj2-team2-manager"
#az deployment group create -n $DeployName_ag -g $RSGroup --template-file $ActionGroup_template --parameters actionGroupName=$ActionGroup_name actionGroupShortName=team2 
#echo "----------------- End [Create Action Group] ---------------------"

echo "--------------------- Start [Create Alert] -----------------------"
# find vm's id
vmIds=($(az vm list -g $RSGroup -o tsv --query "[].id" | tr -s '\n' ' '))
#echo ">>>>>>>>>>> $RSGroup"
#echo $vmIds
idx=0

#find action group id
actionGrpId=$(az monitor action-group list -o tsv --query "[?name=='$ActionGroup_name'].id")

for id in ${vmIds[@]}; do
    # bottleneck os/data disk IOPS
    az monitor metrics alert create -n bottleneck-osdisk-IOPS-$idx -g $RSGroup --scopes $id \
      --condition "avg os disk iops consumed percentage >= 100" \
      --window-size 5m --evaluation-frequency 1m \
      --description "bottleneck-osdisk-IOPS" \
      --action $actionGrpId
    echo ">>>>>>>>>>>>> bottleneck-osdisk-IOPS-$idx"

    az monitor metrics alert create -n bottleneck-datadisk-IOPS-$idx -g $RSGroup --scopes $id \
      --condition "avg data disk iops consumed percentage >= 100" \
      --window-size 5m --evaluation-frequency 1m \
      --description "bottleneck-datadisk-IOPS" \
      --action $actionGrpId
    echo ">>>>>>>>>>>>> bottleneck-datadisk-IOPS-$idx"

    # degrade cpu/badnwidth
    az monitor metrics alert create -n degrade-cpu-$idx -g $RSGroup --scopes $id \
      --condition "avg Percentage CPU > 90" \
      --window-size 5m --evaluation-frequency 1m \
      --description "degrade-cpu" \
      --action $actionGrpId
    echo ">>>>>>>>>>>>> degrade-cpu-$idx"

    az monitor metrics alert create -n degrade-datadisk-bandwidth-$idx -g $RSGroup --scopes $id \
      --window-size 5m --evaluation-frequency 1m \
      --condition "avg data disk bandwidth consumed percentage > 90" \
      --description "degrade-datadisk-bandwidth" \
      --action $actionGrpId
    echo ">>>>>>>>>>>>> degrade-datadisk-bandwidth-$idx"

    az monitor metrics alert create -n degrade-osdisk-bandwidth-$idx -g $RSGroup --scopes $id \
      --window-size 5m --evaluation-frequency 1m \
      --condition "avg os disk bandwidth consumed percentage > 90" \
      --description "degrade-osdisk-bandwidth" \
      --action $actionGrpId
    echo ">>>>>>>>>>>>> degrade-osdisk-bandwidth-$idx"

    (( idx++ ))
done

# find LB's id
lbIds=($(az network lb list -g $RSGroup -o tsv --query "[].id" | tr -s '\n' ' '))
idx=0
for id in ${lbIds[@]}; do
    az monitor metrics alert create -n degrade-lb-$idx -g $RSGroup --scopes $id \
      --condition "avg vipavailability < 90" \
      --window-size 5m --evaluation-frequency 1m \
      --description "degrade-lb-$idx" \
      --action $actionGrpId
    az monitor metrics alert create -n serious-degrade-lb-$idx -g $RSGroup --scopes $id \
      --condition "avg vipavailability < 25" \
      --window-size 5m --evaluation-frequency 1m \
      --description "disable-lb-$idx" \
      --action $actionGrpId

    (( idx++ ))
done

echo "---------------------- End [Create Alert] ------------------------"

#!/bin/bash
# Purpose : Add new user of Azure active directory
# Author : Junghee Yang(junghee.yang@quest-global.com
# Date : 22-July-2021

#  "appId": "0a27719f-5367-4ad0-b4a0-05cc0f9012a8",
#  "displayName": "myOwner",
#  "name": "http://myOwner",
#  "password": "vme4ErvIcSfquP4d-YbQncUG2qVIwSnBpa",
#  "tenant": "fa56d828-2570-43aa-95df-b9aa89663c06"

USER_NAME="0a27719f-5367-4ad0-b4a0-05cc0f9012a8"
USER_PWD="vme4ErvIcSfquP4d-YbQncUG2qVIwSnBpa"
TENANT_ID="fa56d828-2570-43aa-95df-b9aa89663c06"

#echo "az login..."
az login --service-principal --username $USER_NAME --password $USER_PWD --tenant $TENANT_ID

#read csv file

az ad user create --display-name "dev01" \
                  --password "Quest!@#$" \
                  --force-change-password-next-login true \
                  --user-principal-name "dev01@jhsoft.onmicrosoft.com"
#az group create --location WESTUS --name MY_RESOURCE_GROUP

echo "az logout..."
az logout

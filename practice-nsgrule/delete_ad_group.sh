#!/bin/bash
# Purpose : Create a group of Azure active directory
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 22-July-2021
#--------------------------------------------------------------------------

DISPLAY_NAME=$1

az ad group delete --group $DISPLAY_NAME



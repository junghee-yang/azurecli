# !/bin/bash
# Purpose : delete all alert
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 20-Jan-2021
#--------------------------------------------------------------------------
# delete all alert
az monitor metrics alert list -o tsv --query '[].id' | tr -s '\n' ' '| xargs az monitor metrics alert delete --ids

# !/bin/bash
# Purpose : create alerts for vm created with ARM
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 22-Jan-2021
#--------------------------------------------------------------------------

# create workspace
sh optstr-from-csv.sh "csvFiles/logws-param.csv" "az deployment create"

# create alert
# input csv specify parameters

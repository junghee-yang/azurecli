# !/bin/bash
# Purpose: checking status of the command for common usage
# Author : Junghee Yang(junghee.yang@quest-global.com)
# Date : 24-Dec-2020
# ----------------------------------------------------------
check_status() {
    if [ $? -eq 0 ]; then
        echo "succeed"
    else
        echo "fail"
    fi
    exit 0
}

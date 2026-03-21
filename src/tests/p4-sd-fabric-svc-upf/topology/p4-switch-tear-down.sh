#!bin/bash

# You must run this script as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

source "p4-switch-conf-common.sh"

kill_stratum() {
    pkill stratum
}

kill_stratum

exit 0

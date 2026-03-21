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

disable_csum_offloading() {
    ethtool -K ${SW_IFACE_DATA_LEFT} rx off tx off
    ethtool -K ${SW_IFACE_DATA_RIGHT} rx off tx off
}

kill_stratum
disable_csum_offloading

exit 0

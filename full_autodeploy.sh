#!/bin/bash
exec > /home/ubuntu/autodeploy_final.log 2>&1
set -ex
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
cd /home/ubuntu/tfs-main
source my_deploy.sh
./deploy/all.sh

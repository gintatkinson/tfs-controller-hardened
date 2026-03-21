#!/bin/bash

CREDENTIALS="admin:admin"
CONTEXT="admin"
TFS_IP="192.168.5.137"
HEADER="Content-Type: application/json"

##### Raw HTTP requests to provision the UPF TFS service
# curl -X PUT --header "Content-Type: application/json" --data @service-upf.json --user "admin:admin" http://192.168.5.137/tfs-api/context/admin/service/p4-service-upf

curl -X PUT  --header "${HEADER}" --data @service-upf.json --user ${CREDENTIALS} http://${TFS_IP}/tfs-api/context/${CONTEXT}/service/p4-service-upf

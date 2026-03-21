#!/bin/bash

# ---------------------------
# CONFIGURATION
# ---------------------------

TFS_IP="192.168.5.137"

GRAFANA_URL="http://localhost:80/grafana"  # Your Grafana URL
GRAFANA_USERNAME="admin"
GRAFANA_PASSWORD="admin"

DATASOURCE_NAME="Prometheus"
PROMETHEUS_URL="http://${TFS_IP}:30090/"   # URL of your Prometheus server

# ---------------------------
# CREATE DATA SOURCE PAYLOAD
# ---------------------------

read -r -d '' DATA_SOURCE_JSON << EOF
{
  "name": "${DATASOURCE_NAME}",
  "type": "prometheus",
  "access": "proxy",
  "url": "${PROMETHEUS_URL}",
  "basicAuth": false,
  "isDefault": true,
  "editable": true
}
EOF

# ---------------------------
# SEND REQUEST (with username/password)
# ---------------------------

echo "Creating Prometheus datasource in Grafana..."

curl -X POST "${GRAFANA_URL}/api/datasources" \
  -H "Content-Type: application/json" \
  -u "${GRAFANA_USERNAME}:${GRAFANA_PASSWORD}" \
  -d "${DATA_SOURCE_JSON}"

echo
echo "Done"

#!/bin/bash
# TeraFlowSDN ARM64 Recovery Script
# This script restores the 9 core hardened services in the correct sequence.

VM_NAME="tfs-vm-fresh"
NAMESPACE="tfs"
MANIFEST_DIR="/home/ubuntu/tfs-main/manifests"

echo ">>> Initializing TeraFlowSDN ARM64 Recovery..."

# 1. Ensure VM is running
multipass start $VM_NAME

# 2. Wait for MicroK8s
echo ">>> Waiting for MicroK8s..."
multipass exec $VM_NAME -- sg microk8s -c "microk8s status --wait-ready"

# 3. Create Namespace if missing
multipass exec $VM_NAME -- sg microk8s -c "microk8s kubectl create namespace $NAMESPACE" 2>/dev/null

# 4. Sequential Deployment (Hardened for ARM64)
SERVICES=(
  "contextservice"
  "deviceservice"
  "pathcompservice"
  "serviceservice"
  "sliceservice"
  "nbiservice"
  "load_generatorservice"
  "monitoringservice"
  "webuiservice"
)

for service in "${SERVICES[@]}"; do
  echo ">>> Deploying $service..."
  multipass exec $VM_NAME -- sg microk8s -c "microk8s kubectl apply -n $NAMESPACE -f $MANIFEST_DIR/$service.yaml --validate=false"
  echo ">>> Sleeping 20s to allow ARM64 resource stabilization..."
  sleep 20
done

# 5. Fix Ingress Routing
echo ">>> Applying Hardened Ingress (Fixing /tfs-api/ routing)..."
multipass exec $VM_NAME -- sg microk8s -c "microk8s kubectl apply -n $NAMESPACE -f $MANIFEST_DIR/nginx_ingress_http.yaml --validate=false"

echo ">>> Recovery Complete. Verify status with: multipass exec $VM_NAME -- sg microk8s -c \"microk8s kubectl get pods -n $NAMESPACE\""

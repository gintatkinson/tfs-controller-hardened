#!/bin/bash
# TeraFlowSDN Universal Bootstrap Protocol
# Path: controller-develop/bootstrap.sh

set -e

echo ">>> [BOOTSTRAP] Starting Universal Recovery and Re-alignment..."

# 1. Detect Environment & Paths
REPO_ROOT=$(pwd)
PARENT_DIR=$(dirname "$REPO_ROOT")
DMG_NAME="tfs_mirror.dmg"
MOUNT_POINT="/Volumes/TFS_MIRROR"

# 2. Mount the Source of Truth (Case-Sensitive DMG)
if [ ! -d "$MOUNT_POINT" ]; then
    echo ">>> [BOOTSTRAP] Attempting to mount $DMG_NAME..."
    # Check parent dirs (standard dev setup)
    if [ -f "$PARENT_DIR/$DMG_NAME" ]; then
        hdiutil attach "$PARENT_DIR/$DMG_NAME"
    elif [ -f "$PARENT_DIR/../$DMG_NAME" ]; then
        hdiutil attach "$PARENT_DIR/../$DMG_NAME"
    elif [ -f "$HOME/antigravity/scratch/$DMG_NAME" ]; then
        hdiutil attach "$HOME/antigravity/scratch/$DMG_NAME"
    else
        echo ">>> [ERROR] Critical Asset $DMG_NAME not found! Please ensure it is in the scratch directory."
        exit 1
    fi
else
    echo ">>> [BOOTSTRAP] TFS_MIRROR is already mounted."
fi

# 3. Multipass Initialization
if ! command -v multipass &> /dev/null; then
    echo ">>> [ERROR] Multipass is NOT installed. Please 'brew install --cask multipass' and restart."
    exit 1
fi

VM_STATE=$(multipass info tfs-vm-fresh --format json | grep -o '"state": "[^"]*"' | cut -d'"' -f4 || echo "Deleted")

if [[ "$VM_STATE" != "Running" ]]; then
    echo ">>> [BOOTSTRAP] Starting tfs-vm-fresh..."
    multipass start tfs-vm-fresh || (echo ">>> [ERROR] VM 'tfs-vm-fresh' not found. Re-creation required." && exit 1)
else
    echo ">>> [BOOTSTRAP] VM 'tfs-vm-fresh' is already running."
fi

# 4. Sync Code to VM (Ensuring Mission Continuity)
echo ">>> [BOOTSTRAP] Syncing repository assets to VM..."
# Zip and transfer to avoid permission/recursive issues
tar --exclude .git -czf /tmp/tfs_sync.tar.gz .
multipass transfer /tmp/tfs_sync.tar.gz tfs-vm-fresh:/home/ubuntu/
multipass exec tfs-vm-fresh -- tar -xzf /home/ubuntu/tfs_sync.tar.gz -C /home/ubuntu/tfs-main/
rm /tmp/tfs_sync.tar.gz

# 5. Automated Image Reconstruction (If local registry is empty)
echo ">>> [BOOTSTRAP] Checking for local ARM64 images..."
IMAGE_COUNT=$(multipass exec tfs-vm-fresh -- docker images --format "{{.Repository}}:{{.Tag}}" | grep "localhost:32000" | wc -l || echo "0")

if [ "$IMAGE_COUNT" -lt 10 ]; then
    echo ">>> [BOOTSTRAP] Local registry is empty. Triggering full ARM64 rebuild from source..."
    multipass exec tfs-vm-fresh -- /home/ubuntu/tfs-main/deploy/all.sh || (echo ">>> [ERROR] Rebuild Failed." && exit 1)
else
    echo ">>> [BOOTSTRAP] Found $IMAGE_COUNT local images. Skipping rebuild."
fi

# 6. Trigger Internal Recovery (Host-Side Orchestrator)
echo ">>> [BOOTSTRAP] Running recovery orchestrator..."
chmod +x recovery.sh
./recovery.sh || (echo ">>> [ERROR] Recovery Failed. Check logs." && exit 1)

echo ">>> [SUCCESS] Universal Bootstrap Complete. Mission Ready."

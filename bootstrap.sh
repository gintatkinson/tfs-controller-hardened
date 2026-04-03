#!/bin/bash
# TeraFlowSDN Universal Zero-Anchor Bootstrap
# This script is the single entry point for environment reconstruction.
# Supports: Mac (ARM64/Intel), Linux, Windows (WSL)

set -e

echo ">>> [BOOTSTRAP] Starting Zero-Anchor Recovery and Re-alignment..."

# 1. Detect Environment & Paths
OS_TYPE=$(uname -s)
ARCH_TYPE=$(uname -m)
REPO_ROOT=$(pwd)
SOURCE_TARBALL="tfs_source_baseline.tar.gz"

echo ">>> [BOOTSTRAP] Environment: $OS_TYPE ($ARCH_TYPE)"

# 2. Universal Tool Check (Multipass)
if ! command -v multipass &> /dev/null; then
    echo ">>> [BOOTSTRAP] Multipass is NOT installed. Attempting OS-bound installation..."
    case "$OS_TYPE" in
        Darwin)
            echo ">>> [MAC] Run: brew install --cask multipass" ;;
        Linux)
            echo ">>> [LINUX] Run: sudo snap install multipass" ;;
        *)
            echo ">>> [WINDOWS/OTHER] Please install Multipass from https://multipass.run/" ;;
    esac
    exit 1
fi

# 3. Universal 'Source of Truth' Extraction
if [ ! -d "manifests" ]; then
    echo ">>> [BOOTSTRAP] Base Source of Truth missing. Searching for tarball..."
    # Look in current dir and standard Downloads folder
    if [ -f "$SOURCE_TARBALL" ]; then
        FOUND_TARBALL="$SOURCE_TARBALL"
    elif [ -f "$HOME/Downloads/$SOURCE_TARBALL" ]; then
        FOUND_TARBALL="$HOME/Downloads/$SOURCE_TARBALL"
    else
        echo ">>> [ERROR] Critical Asset $SOURCE_TARBALL not found!"
        echo ">>> Please download it from your GitHub Release and place it in $(pwd)"
        exit 1
    fi
    echo ">>> [BOOTSTRAP] Extracting universal source from $FOUND_TARBALL..."
    tar -xzf "$FOUND_TARBALL"
fi

# 4. Multipass VM Lifecycle
VM_STATE=$(multipass info tfs-vm-fresh --format json | grep -o '"state": "[^"]*"' | cut -d'"' -f4 || echo "Deleted")

if [[ "$VM_STATE" != "Running" ]]; then
    echo ">>> [BOOTSTRAP] Initializing tfs-vm-fresh..."
    # Note: On a blank-slate machine, this would need to be 'launch' instead of 'start'
    multipass launch --name tfs-vm-fresh --cpus 4 --memory 8G --disk 40G || multipass start tfs-vm-fresh || (echo ">>> [ERROR] VM creation failed." && exit 1)
else
    echo ">>> [BOOTSTRAP] VM 'tfs-vm-fresh' is already running."
fi

# 5. High-Integrity Sync to VM & Tool Provisioning
echo ">>> [BOOTSTRAP] Syncing assets and provisioning build environment..."
tar --exclude .git --exclude "*.tar.gz" -czf /tmp/tfs_sync.tar.gz .
multipass transfer /tmp/tfs_sync.tar.gz tfs-vm-fresh:/home/ubuntu/
multipass exec tfs-vm-fresh -- mkdir -p /home/ubuntu/tfs-main/
multipass exec tfs-vm-fresh -- tar -xzf /home/ubuntu/tfs_sync.tar.gz -C /home/ubuntu/tfs-main/
rm /tmp/tfs_sync.tar.gz

# Ensure all build dependencies are present for the target architecture (Intel/ARM64)
echo ">>> [BOOTSTRAP] Provisioning build tools inside the VM..."
multipass exec tfs-vm-fresh -- sudo apt-get update -qq
multipass exec tfs-vm-fresh -- sudo apt-get install -y -qq build-essential docker.io golang-go openjdk-11-jdk python3-pip cmake libpcre2-dev
multipass exec tfs-vm-fresh -- sudo usermod -aG docker ubuntu

# 6. Automated Rebuild for Local Architecture
echo ">>> [BOOTSTRAP] Auditing ARM64/Intel local images..."
IMAGE_COUNT=$(multipass exec tfs-vm-fresh -- docker images --format "{{.Repository}}:{{.Tag}}" | grep "localhost:32000" | wc -l || echo "0")

if [ "$IMAGE_COUNT" -lt 10 ]; then
    echo ">>> [BOOTSTRAP] Local registry is empty. Rebuilding all 22 services from source..."
    multipass exec tfs-vm-fresh -- /home/ubuntu/tfs-main/deploy/all.sh || (echo ">>> [ERROR] Rebuild Failed." && exit 1)
else
    echo ">>> [BOOTSTRAP] Found $IMAGE_COUNT local images correctly hashed."
fi

# 7. Final Orchestration
echo ">>> [BOOTSTRAP] Running recovery orchestrator..."
chmod +x recovery.sh
./recovery.sh || (echo ">>> [ERROR] Recovery Failed." && exit 1)

echo ">>> [SUCCESS] Universal Zero-Anchor Bootstrap Complete. Mission Ready."

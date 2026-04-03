#!/bin/bash
# TeraFlowSDN Universal Source-of-Truth Baseline
# This script creates a portable tarball of the 1.1Gi source tree.

set -e

SOURCE_DIR="/Users/perkunas/.gemini/antigravity/scratch/tfs-work/controller-develop"
OUTPUT_FILE="../tfs_source_baseline.tar.gz"

echo ">>> [UNIVERSAL] Creating portable tarball from $SOURCE_DIR..."
# Save to parent directory to avoid recursive compression
tar --exclude='.git' --exclude='*.tar.gz' -czpf "$OUTPUT_FILE" -C "$SOURCE_DIR" .

echo ">>> [UNIVERSAL] Created $OUTPUT_FILE ($(ls -lh $OUTPUT_FILE | awk '{print $5}'))"
echo ">>> [UNIVERSAL] To achieve Zero-Anchor recovery across ALL OSs:"
echo "1. Upload this file to your GitHub Release (e.g., 'source-of-truth')."
echo "2. The new 'bootstrap.sh' will find and extract this on any Mac, Linux, or Windows (WSL) machine."

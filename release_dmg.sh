#!/bin/bash
# TeraFlowSDN 'Source of Truth' Release Script
# This script splits the 5Gi tfs_mirror.dmg and prepares it for GitHub Release.

set -e

DMG_PATH="/Users/perkunas/.gemini/antigravity/scratch/tfs_mirror.dmg"
RELEASE_TAG="source-of-truth"

echo ">>> [RELEASE] Splitting $DMG_PATH into 2Gi chunks..."
mkdir -p ./release_assets
split -b 2048m "$DMG_PATH" "./release_assets/tfs_mirror_part_"

echo ">>> [RELEASE] Chunks created in ./release_assets/:"
ls -lh ./release_assets/

echo ">>> [RELEASE] To finalize the Zero-Anchor recovery, please:"
echo "1. Create a GitHub Release titled '$RELEASE_TAG'."
echo "2. Upload all chunks from ./release_assets/ to that release."
echo "3. The bootstrap.sh script will now be able to reconstruct this asset from any blank-slate machine."

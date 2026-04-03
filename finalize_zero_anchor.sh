#!/bin/bash
# TeraFlowSDN Zero-Anchor Recovery Finalizer
# This script externalizes the 247MB Source of Truth to GitHub.

set -e

SOURCE_TARBALL="../tfs_source_baseline.tar.gz"
RELEASE_TAG="source-of-truth"
REPO="gintatkinson/tfs-controller-hardened"

if [ ! -f "$SOURCE_TARBALL" ]; then
    echo ">>> [ERROR] Tarball NOT found at $SOURCE_TARBALL. Run create_universal_tarball.sh first."
    exit 1
fi

echo ">>> [FINALIZER] Preparing for GitHub Release of $SOURCE_TARBALL..."

# 1. Check GitHub CLI Authentication
if ! gh auth status &> /dev/null; then
    echo ">>> [AUTHENTICATION] GitHub CLI is not logged in."
    echo ">>> Please run: 'gh auth login' or provide your PAT."
    # We stop here because the agent cannot type passwords for you.
    exit 1
fi

# 2. Create the Release (if missing)
echo ">>> [RELEASE] Checking for release $RELEASE_TAG..."
if ! gh release view "$RELEASE_TAG" --repo "$REPO" &> /dev/null; then
    echo ">>> [RELEASE] Creating new release $RELEASE_TAG..."
    gh release create "$RELEASE_TAG" --repo "$REPO" --title "TFS Source Baseline (Zero-Anchor)" --notes "This is the 247MB universal source-of-truth for the TeraFlowSDN architecture."
fi

# 3. Upload the Asset
echo ">>> [UPLOAD] Uploading $SOURCE_TARBALL..."
gh release upload "$RELEASE_TAG" "$SOURCE_TARBALL" --repo "$REPO" --clobber

echo ">>> [SUCCESS] Zero-Anchor Recovery is now fully externalized to GitHub."
echo ">>> [VERIFY] You can now safely lose this machine."
echo ">>> [VERIFY] https://github.com/$REPO/releases/tag/$RELEASE_TAG"

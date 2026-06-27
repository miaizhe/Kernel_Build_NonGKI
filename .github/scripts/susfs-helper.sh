#!/bin/bash
# SuSFS Patch Helper Script
# Downloads and applies SuSFS (Suspicious Feature Suppression File System) patches

set -e

KERNEL_DIR="${1:-.}"
REFERENCE_REPO="https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd"
BRANCH="mainline"
FIXED="${2:-false}"

echo "=== SuSFS Patch Helper ==="
echo "Kernel directory: $KERNEL_DIR"
echo "Fixed mode: $FIXED"

cd "$KERNEL_DIR"

# Download SuSFS patch script
echo "Downloading susfs_patches.sh..."
curl -LSs "${REFERENCE_REPO}/raw/${BRANCH}/Patches/SuSFS/susfs_patches.sh" -o susfs_patches.sh || {
    echo "Warning: Could not download susfs_patches.sh, skipping..."
    exit 0
}
chmod +x susfs_patches.sh

# Apply SuSFS patches
echo "Applying SuSFS patches..."
bash susfs_patches.sh

echo "SuSFS patches applied successfully!"

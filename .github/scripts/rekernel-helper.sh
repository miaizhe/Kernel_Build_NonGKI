#!/bin/bash
# Re:Kernel Patch Helper Script
# Downloads and applies Re:Kernel patches from the reference repository

set -e

KERNEL_DIR="${1:-.}"
REFERENCE_REPO="https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd"
BRANCH="mainline"

echo "=== Re:Kernel Patch Helper ==="
echo "Kernel directory: $KERNEL_DIR"
echo "Reference repository: $REFERENCE_REPO"

cd "$KERNEL_DIR"

# Download Re:Kernel patch script
echo "Downloading rekernel_patches.sh..."
curl -LSs "${REFERENCE_REPO}/raw/${BRANCH}/Patches/Rekernel/rekernel_patches.sh" -o rekernel_patches.sh
chmod +x rekernel_patches.sh

# Apply Re:Kernel patches
echo "Applying Re:Kernel patches..."
bash rekernel_patches.sh

# Download and apply extra patch
echo "Downloading rekernel_extra.patch..."
mkdir -p drivers/rekernel
curl -LSs "${REFERENCE_REPO}/raw/${BRANCH}/Patches/Rekernel/rekernel_extra.patch" -o rekernel_extra.patch
patch -p1 < rekernel_extra.patch || true

echo "Re:Kernel patches applied successfully!"

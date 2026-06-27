#!/bin/bash
# Syscall Hook Patches Helper Script
# Downloads and applies syscall-based KernelSU hook patches

set -e

KERNEL_DIR="${1:-.}"
REFERENCE_REPO="https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd"
BRANCH="mainline"

echo "=== Syscall Hook Patches Helper ==="
echo "Kernel directory: $KERNEL_DIR"

cd "$KERNEL_DIR"

# Download syscall hook patch script
echo "Downloading syscall_hook_patches.sh..."
curl -LSs "${REFERENCE_REPO}/raw/${BRANCH}/Patches/syscall_hook_patches.sh" -o syscall_hook_patches.sh
chmod +x syscall_hook_patches.sh

# Apply syscall hook patches
echo "Applying syscall hook patches..."
bash syscall_hook_patches.sh

echo "Syscall hooks applied successfully!"

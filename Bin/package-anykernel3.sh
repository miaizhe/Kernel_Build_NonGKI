#!/bin/bash
# AnyKernel3 Packaging Script
# Creates flashable ZIP package from compiled kernel

set -e

KERNEL_IMAGE="${1:-}"
KERNEL_SOURCE_DIR="${2:-.}"
OUTPUT_DIR="${3:-.}"
AK3_SOURCE="${4:-https://github.com/osm0sis/AnyKernel3.git}"
AK3_BRANCH="${5:-master}"
PACK_MODULES="${6:-false}"
CUSTOM_MESSAGE="${7:-}"

echo "=== AnyKernel3 Packaging ==="
echo "Kernel image: $KERNEL_IMAGE"
echo "Output directory: $OUTPUT_DIR"

if [ -z "$KERNEL_IMAGE" ]; then
    echo "ERROR: Kernel image path not specified"
    exit 1
fi

if [ ! -f "$KERNEL_IMAGE" ]; then
    echo "ERROR: Kernel image not found: $KERNEL_IMAGE"
    exit 1
fi

# Clone AnyKernel3
echo "Cloning AnyKernel3..."
git clone -b "$AK3_BRANCH" "$AK3_SOURCE" AnyKernel3

# Copy kernel image
echo "Copying kernel image..."
cp "$KERNEL_IMAGE" AnyKernel3/

# Copy kernel modules if enabled
if [ "$PACK_MODULES" = "true" ]; then
    echo "Packing kernel modules..."
    mkdir -p AnyKernel3/modules/vendor/lib/modules
    find "$KERNEL_SOURCE_DIR" -name "*.ko" -exec cp {} AnyKernel3/modules/vendor/lib/modules/ \; 2>/dev/null || true
fi

# Customize flash message if provided
if [ -n "$CUSTOM_MESSAGE" ]; then
    echo "Customizing flash message..."
    if [ -f "AnyKernel3/META-INF/com/google/android/update-binary" ]; then
        sed -i "584s|ui_print \" \" \"Done!\";|ui_print \" \"; ui_print \"${CUSTOM_MESSAGE}\";|" "AnyKernel3/META-INF/com/google/android/update-binary" 2>/dev/null || true
    fi
fi

# Create output ZIP
cd AnyKernel3
DEVICE_NAME=${DEVICE_NAME:-device}
BUILD_DATE=${BUILD_DATE:-$(date +%Y%m%d)}
OUTPUT_NAME="NonGKI-Kernel-${DEVICE_NAME}-${BUILD_DATE}.zip"

echo "Creating ZIP package: $OUTPUT_NAME"
zip -r9 "../$OUTPUT_NAME" * -x .git* README.md *placeholder

cd ..
echo "Packaging complete: $OUTPUT_NAME"
echo "$OUTPUT_NAME"

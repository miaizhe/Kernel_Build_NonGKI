#!/bin/bash
# Boot Image Repacking Script
# Uses magiskboot to repack boot image with new kernel

set -e

KERNEL_IMAGE="${1:-}"
BOOT_IMAGE="${2:-}"
OUTPUT_IMAGE="${3:-}"
MAGISKBOOT_URL="${4:-}"

echo "=== Boot Image Repacking ==="
echo "Kernel image: $KERNEL_IMAGE"
echo "Boot image: $BOOT_IMAGE"
echo "Output image: $OUTPUT_IMAGE"

if [ -z "$KERNEL_IMAGE" ] || [ -z "$BOOT_IMAGE" ] || [ -z "$OUTPUT_IMAGE" ]; then
    echo "ERROR: Missing required parameters"
    echo "Usage: $0 <kernel_image> <boot_image> <output_image> [magiskboot_url]"
    exit 1
fi

if [ ! -f "$KERNEL_IMAGE" ]; then
    echo "ERROR: Kernel image not found: $KERNEL_IMAGE"
    exit 1
fi

if [ ! -f "$BOOT_IMAGE" ]; then
    echo "ERROR: Boot image not found: $BOOT_IMAGE"
    exit 1
fi

# Download magiskboot if not provided
if [ -z "$MAGISKBOOT_URL" ]; then
    MAGISKBOOT_URL="https://github.com/topjohnwu/magisk_files/raw/main/stable/magiskboot"
fi

# Create temporary directory
WORK_DIR=$(mktemp -d)
cd "$WORK_DIR"

# Download magiskboot
echo "Downloading magiskboot..."
wget -q "$MAGISKBOOT_URL" -O magiskboot
chmod +x magiskboot

# Unpack boot image
echo "Unpacking boot image..."
./magiskboot unpack "$BOOT_IMAGE"

if [ ! -f boot.img ]; then
    echo "ERROR: Failed to unpack boot image"
    rm -rf "$WORK_DIR"
    exit 1
fi

# Replace kernel
echo "Replacing kernel..."
cp "$KERNEL_IMAGE" kernel

# Repack boot image
echo "Repacking boot image..."
./magiskboot repack boot.img "$OUTPUT_IMAGE"

if [ -f "$OUTPUT_IMAGE" ]; then
    echo "Boot image repacked successfully: $OUTPUT_IMAGE"
    mv "$OUTPUT_IMAGE" "${3}"
else
    echo "ERROR: Failed to repack boot image"
    rm -rf "$WORK_DIR"
    exit 1
fi

# Cleanup
rm -rf "$WORK_DIR"
echo "Boot image repacking complete!"

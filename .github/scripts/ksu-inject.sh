#!/bin/bash
# KernelSU Injection Helper Script
# Downloads and applies KernelSU patches based on fork selection

set -e

KERNEL_DIR="${1:-.}"
KSU_FORK="${2:-tiann}"
KSU_BRANCH="${3:-main}"

echo "=== KernelSU Injection Helper ==="
echo "Kernel directory: $KERNEL_DIR"
echo "KernelSU fork: $KSU_FORK"
echo "KernelSU branch: $KSU_BRANCH"

cd "$KERNEL_DIR"

# Determine KernelSU source URL based on fork
case "$KSU_FORK" in
    tiann)
        KSU_SOURCE="https://raw.githubusercontent.com/tiann/KernelSU/${KSU_BRANCH}/kernel/setup.sh"
        ;;
    rsuntk)
        KSU_SOURCE="https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh"
        ;;
    next)
        KSU_SOURCE="https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/main/kernel/setup.sh"
        ;;
    resukisu)
        KSU_SOURCE="https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh"
        ;;
    sukisu)
        KSU_SOURCE="https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh"
        ;;
    *)
        echo "Unknown KernelSU fork: $KSU_FORK, using default (tiann)"
        KSU_SOURCE="https://raw.githubusercontent.com/tiann/KernelSU/${KSU_BRANCH}/kernel/setup.sh"
        ;;
esac

echo "Downloading KernelSU setup script from: $KSU_SOURCE"
curl -LSs "$KSU_SOURCE" | bash

echo "KernelSU injected successfully!"

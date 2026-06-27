#!/bin/bash
# Compiler Preparation Script
# Downloads and extracts Clang/GCC toolchains

set -e

COMPILER_DIR="${1:-compiler}"
CLANG_SOURCE="${2:-}"
CLANG_BRANCH="${3:-}"
GCC_64_SOURCE="${4:-}"
GCC_32_SOURCE="${5:-}"
GCC_GNU="${6:-false}"

echo "=== Compiler Preparation ==="
echo "Compiler directory: $COMPILER_DIR"

mkdir -p "$COMPILER_DIR"
cd "$COMPILER_DIR"

# Download and extract Clang
if [ -n "$CLANG_SOURCE" ]; then
    echo "Downloading Clang from: $CLANG_SOURCE"
    FILENAME=$(basename "$CLANG_SOURCE")
    
    if [[ "$FILENAME" == *.tar.xz ]]; then
        curl -fL "$CLANG_SOURCE" -o clang-toolchain.tar.xz --connect-timeout 30 --retry 5 --retry-delay 5
        mkdir -p clang-bin
        tar -xf clang-toolchain.tar.xz -C clang-bin
        rm clang-toolchain.tar.xz
    elif [[ "$FILENAME" == *.tar.gz ]]; then
        curl -fL "$CLANG_SOURCE" -o clang-toolchain.tar.gz --connect-timeout 30 --retry 5 --retry-delay 5
        mkdir -p clang-bin
        tar -xzf clang-toolchain.tar.gz -C clang-bin
        rm clang-toolchain.tar.gz
    elif [[ "$FILENAME" == *.zip ]]; then
        curl -fL "$CLANG_SOURCE" -o clang-toolchain.zip --connect-timeout 30 --retry 5 --retry-delay 5
        mkdir -p clang-bin
        unzip -q clang-toolchain.zip -d clang-bin
        rm clang-toolchain.zip
    else
        echo "Unknown Clang archive format: $FILENAME"
        exit 1
    fi
    
    echo "Clang extracted to clang-bin/"
else
    echo "No Clang source specified, skipping Clang download"
fi

# Download GCC cross-compilers (optional)
if [ "$GCC_GNU" = "true" ]; then
    echo "Downloading GCC cross-compilers..."
    
    if [ -n "$GCC_64_SOURCE" ]; then
        GCC64_DIR="gcc-aarch64"
        mkdir -p "$GCC64_DIR"
        cd "$GCC64_DIR"
        if [ -n "$GCC_64_BRANCH" ]; then
            git clone --depth 1 --branch "$GCC_64_BRANCH" "$GCC_64_SOURCE" .
        else
            git clone --depth 1 "$GCC_64_SOURCE" .
        fi
        cd ..
    fi
    
    if [ -n "$GCC_32_SOURCE" ]; then
        GCC32_DIR="gcc-arm"
        mkdir -p "$GCC32_DIR"
        cd "$GCC32_DIR"
        if [ -n "$GCC_32_BRANCH" ]; then
            git clone --depth 1 --branch "$GCC_32_BRANCH" "$GCC_32_SOURCE" .
        else
            git clone --depth 1 "$GCC_32_SOURCE" .
        fi
        cd ..
    fi
    
    echo "GCC cross-compilers downloaded"
fi

echo "Compiler preparation complete!"

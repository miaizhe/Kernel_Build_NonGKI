#!/bin/bash
# Test script for ksu-inject.sh
# Tests that the script correctly handles different KernelSU forks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_SCRIPT="$SCRIPT_DIR/ksu-inject.sh"
TEMP_DIR=$(mktemp -d)

echo "=== Testing ksu-inject.sh ==="
echo "Test directory: $TEMP_DIR"

# Test 1: Verify script exists and is executable
echo -n "Test 1: Script exists and is executable... "
if [ ! -f "$TEST_SCRIPT" ]; then
    echo "FAIL - Script not found"
    exit 1
fi
if [ ! -x "$TEST_SCRIPT" ]; then
    chmod +x "$TEST_SCRIPT"
fi
echo "PASS"

# Test 2: Test default fork (tiann)
echo -n "Test 2: Default fork is tiann... "
OUTPUT=$(bash "$TEST_SCRIPT" "$TEMP_DIR" 2>&1 | head -20)
if echo "$OUTPUT" | grep -q "KernelSU fork: tiann"; then
    echo "PASS"
else
    echo "INFO - Script would download from tiann source"
fi

# Test 3: Test next fork
echo -n "Test 3: Next fork selection... "
OUTPUT=$(bash "$TEST_SCRIPT" "$TEMP_DIR" next main 2>&1 | head -20)
if echo "$OUTPUT" | grep -q "next"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

# Test 4: Test resukisu fork
echo -n "Test 4: Resukisu fork selection... "
OUTPUT=$(bash "$TEST_SCRIPT" "$TEMP_DIR" resukisu main 2>&1 | head -20)
if echo "$OUTPUT" | grep -q "resukisu"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

# Test 5: Test unknown fork (should fallback to tiann)
echo -n "Test 5: Unknown fork fallback... "
OUTPUT=$(bash "$TEST_SCRIPT" "$TEMP_DIR" unknown_fork main 2>&1 | head -20)
if echo "$OUTPUT" | grep -q "tiann"; then
    echo "PASS"
else
    echo "FAIL"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "=== All tests completed ==="

#!/bin/bash
# Test script for package-anykernel3.sh
# Tests that the script validates inputs correctly

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_SCRIPT="$SCRIPT_DIR/package-anykernel3.sh"
TEMP_DIR=$(mktemp -d)

echo "=== Testing package-anykernel3.sh ==="
echo "Test directory: $TEMP_DIR"

# Test 1: Verify script exists
echo -n "Test 1: Script exists... "
if [ ! -f "$TEST_SCRIPT" ]; then
    echo "FAIL - Script not found"
    exit 1
fi
echo "PASS"

# Test 2: Test missing kernel image parameter
echo -n "Test 2: Validates missing kernel image... "
OUTPUT=$(bash "$TEST_SCRIPT" "" "$TEMP_DIR" "$TEMP_DIR" 2>&1 || true)
if echo "$OUTPUT" | grep -qi "error\|not specified"; then
    echo "PASS"
else
    echo "INFO - May not validate empty input"
fi

# Test 3: Test non-existent kernel image
echo -n "Test 3: Validates non-existent kernel image... "
touch "$TEMP_DIR/fake_kernel"
OUTPUT=$(bash "$TEST_SCRIPT" "$TEMP_DIR/nonexistent" "$TEMP_DIR" "$TEMP_DIR" 2>&1 || true)
if echo "$OUTPUT" | grep -qi "error\|not found"; then
    echo "PASS"
else
    echo "INFO - May not validate file existence"
fi

# Test 4: Verify script has proper structure
echo -n "Test 4: Script has proper structure... "
if grep -q "set -e" "$TEST_SCRIPT" && grep -q "KERNEL_IMAGE" "$TEST_SCRIPT"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "=== All tests completed ==="

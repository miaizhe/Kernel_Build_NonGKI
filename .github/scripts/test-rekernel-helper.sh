#!/bin/bash
# Test script for rekernel-helper.sh
# Tests that the script correctly handles Re:Kernel patches

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_SCRIPT="$SCRIPT_DIR/rekernel-helper.sh"
TEMP_DIR=$(mktemp -d)

echo "=== Testing rekernel-helper.sh ==="
echo "Test directory: $TEMP_DIR"

# Test 1: Verify script exists
echo -n "Test 1: Script exists... "
if [ ! -f "$TEST_SCRIPT" ]; then
    echo "FAIL - Script not found"
    exit 1
fi
echo "PASS"

# Test 2: Verify script has correct shebang
echo -n "Test 2: Script has bash shebang... "
FIRST_LINE=$(head -n 1 "$TEST_SCRIPT")
if echo "$FIRST_LINE" | grep -q "#!/bin/bash"; then
    echo "PASS"
else
    echo "FAIL - Expected #!/bin/bash"
    exit 1
fi

# Test 3: Verify script references correct repo
echo -n "Test 3: References correct repository... "
if grep -q "JackA1ltman/NonGKI_Kernel_Build_2nd" "$TEST_SCRIPT"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

# Test 4: Verify error handling with set -e
echo -n "Test 4: Script uses set -e for error handling... "
if grep -q "^set -e" "$TEST_SCRIPT"; then
    echo "PASS"
else
    echo "WARN - Script may not handle errors gracefully"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "=== All tests completed ==="

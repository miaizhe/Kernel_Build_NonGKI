#!/bin/bash
# Main test runner for NonGKI Kernel Build project
# Runs all tests in sequence

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PASS_COUNT=0
FAIL_COUNT=0
TOTAL_COUNT=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo " NonGKI Kernel Build - Test Suite"
echo "================================================"
echo ""

# Function to run a test
run_test() {
    local test_name="$1"
    local test_script="$2"
    
    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    echo "[$TOTAL_COUNT] Running: $test_name"
    echo "----------------------------------------"
    
    if [ -f "$test_script" ]; then
        cd "$PROJECT_DIR"
        bash "$test_script"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ PASS${NC}: $test_name"
            PASS_COUNT=$((PASS_COUNT + 1))
        else
            echo -e "${RED}✗ FAIL${NC}: $test_name"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    else
        echo -e "${YELLOW}⊘ SKIP${NC}: $test_script not found"
    fi
    echo ""
}

# Run all tests
run_test "KernelSU Inject Script" ".github/scripts/test-ksu-inject.sh"
run_test "Re:Kernel Helper Script" ".github/scripts/test-rekernel-helper.sh"
run_test "Package AnyKernel3 Script" "Bin/test-package-anykernel3.sh"
run_test "Workflow YAML Syntax" "tests/test-workflow-syntax.sh"

# Summary
echo "================================================"
echo " Test Summary"
echo "================================================"
echo -e "Total:  $TOTAL_COUNT"
echo -e "Passed: ${GREEN}$PASS_COUNT${NC}"
if [ $FAIL_COUNT -gt 0 ]; then
    echo -e "Failed: ${RED}$FAIL_COUNT${NC}"
else
    echo -e "Failed: $FAIL_COUNT"
fi
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi

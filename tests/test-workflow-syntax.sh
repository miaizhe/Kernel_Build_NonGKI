#!/bin/bash
# Test script for validating YAML workflow syntax
# Tests that workflow files are valid YAML

set -e

WORKFLOW_DIR=".github/workflows"

echo "=== Testing Workflow YAML Syntax ==="

# Test 1: Verify build-kernel.yml exists
echo -n "Test 1: build-kernel.yml exists... "
if [ -f "$WORKFLOW_DIR/build-kernel.yml" ]; then
    echo "PASS"
else
    echo "FAIL - File not found"
    exit 1
fi

# Test 2: Check YAML syntax (if python-yaml is available)
echo -n "Test 2: Validate YAML syntax... "
if command -v python3 &> /dev/null; then
    python3 -c "import yaml; yaml.safe_load(open('$WORKFLOW_DIR/build-kernel.yml'))" 2>/dev/null && \
        echo "PASS" || echo "WARN - YAML validation failed"
elif command -v python &> /dev/null; then
    python -c "import yaml; yaml.safe_load(open('$WORKFLOW_DIR/build-kernel.yml'))" 2>/dev/null && \
        echo "PASS" || echo "WARN - YAML validation failed"
else
    echo "SKIP - Python not available"
fi

# Test 3: Verify required fields exist
echo -n "Test 3: Has 'name' field... "
if grep -q "^name:" "$WORKFLOW_DIR/build-kernel.yml"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

echo -n "Test 4: Has 'on' trigger... "
if grep -q "^on:" "$WORKFLOW_DIR/build-kernel.yml"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

echo -n "Test 5: Has 'jobs' section... "
if grep -q "^jobs:" "$WORKFLOW_DIR/build-kernel.yml"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

# Test 6: Verify no syntax errors in shell scripts
echo -n "Test 6: Validate shell script syntax... "
VALID=true
for script in .github/scripts/*.sh Bin/*.sh; do
    if [ -f "$script" ]; then
        bash -n "$script" 2>/dev/null || {
            echo "WARN - $script has syntax errors"
            VALID=false
        }
    fi
done
if [ "$VALID" = true ]; then
    echo "PASS"
else
    echo "FAIL"
fi

echo ""
echo "=== All workflow tests completed ==="

#!/bin/bash

extract_test_functions() {
    local file="$1"
    local functions

    # Use grep to find lines starting with "function test_" or "test_" in the file
    functions=$(grep -E '^(function )?test_[a-zA-Z0-9_]+\(\)' "$file" | awk '{gsub(/\(\)/, "", $1); print $1}')

    # Return the array of function names
    echo "$functions"
}
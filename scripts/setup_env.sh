#!/bin/bash

set -euo pipefail

echo "Checking required tools..."

for tool in bash grep awk sed tr; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Error: $tool not found."
        exit 1
    fi

    echo "$tool: OK"
done

echo "All required tools are available."

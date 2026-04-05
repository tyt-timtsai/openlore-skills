#!/usr/bin/env bash
# Check if openlore-mcp is installed and meets minimum version requirements.
# Used by session-start hook for compatibility verification.

MIN_VERSION="0.1.0"

if ! command -v openlore-mcp &>/dev/null; then
  echo "NOT_INSTALLED"
  exit 1
fi

VERSION=$(openlore-mcp --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "0.0.0")
echo "$VERSION"

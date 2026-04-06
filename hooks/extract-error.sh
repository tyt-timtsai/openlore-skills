#!/usr/bin/env bash
# Extract error from PostToolUseFailure hook input and query OpenLore.
# Input: JSON on stdin with .tool_response field
# Output: JSON with hookSpecificOutput if fixes found, empty otherwise

# Check if openlore-mcp is available
if ! command -v openlore-mcp &>/dev/null; then
  exit 0
fi

# Read the tool response from stdin (piped from hook)
ERROR_TEXT=$(jq -r '.tool_response // ""' 2>/dev/null | head -c 2000)

if [ -z "$ERROR_TEXT" ]; then
  exit 0
fi

# Query OpenLore with the error text
openlore-mcp query "$ERROR_TEXT" --json 2>/dev/null

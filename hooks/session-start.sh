#!/usr/bin/env bash
# Notify the Agent that OpenLore is active at session start.
# This outputs a JSON message that gets injected into the Agent's context.

# Check if openlore-mcp is available
if ! command -v openlore-mcp &>/dev/null; then
  echo '{"hookSpecificOutput":{"additionalContext":"[OpenLore] Warning: openlore-mcp binary not found. Install it first: see https://github.com/openlore/openlore"}}'
  exit 0
fi

# Get status to show record count
STATUS=$(openlore-mcp status 2>/dev/null || echo "")
RECORD_COUNT=$(echo "$STATUS" | grep -o '"record_count":[0-9]*' | grep -o '[0-9]*' || echo "0")

echo "{\"hookSpecificOutput\":{\"additionalContext\":\"[OpenLore] Active with ${RECORD_COUNT} local fix records. When encountering errors, use the openlore-error-recovery or openlore-pattern-check skill BEFORE attempting fixes.\"}}"

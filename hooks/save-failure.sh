#!/usr/bin/env bash
# Save failure state for success-after-failure detection.
# Runs on PostToolUseFailure (Bash). Companion: check-success.sh on PostToolUse.

DATA_DIR="${CLAUDE_PLUGIN_DATA:-/tmp/openlore-hooks}"
mkdir -p "$DATA_DIR"

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
ERROR=$(echo "$INPUT" | jq -r '.error // .tool_response // ""' | head -c 2000)

if [ -z "$COMMAND" ] || [ -z "$ERROR" ]; then
  exit 0
fi

# Base command = first 2 tokens (e.g., "cargo build", "npm test", "python -m")
BASE_CMD=$(echo "$COMMAND" | awk '{print $1, $2}')

jq -n \
  --arg cmd "$COMMAND" \
  --arg base "$BASE_CMD" \
  --arg err "$ERROR" \
  --arg ts "$(date +%s)" \
  '{command: $cmd, base_command: $base, error: $err, timestamp: ($ts | tonumber)}' \
  > "$DATA_DIR/last_failure.json"

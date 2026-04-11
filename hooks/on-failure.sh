#!/usr/bin/env bash
# PostToolUseFailure handler: query OpenLore + save failure state.
# Combines extract-error.sh + save-failure.sh into one script
# to avoid stdin/matcher issues with multiple hook entries.

INPUT=$(cat)

# --- Part 1: Query OpenLore for known fixes ---
if command -v openlore-mcp &>/dev/null; then
  ERROR_TEXT=$(echo "$INPUT" | jq -r '.tool_response // ""' | head -c 2000)
  if [ -n "$ERROR_TEXT" ]; then
    openlore-mcp query "$ERROR_TEXT" --json 2>/dev/null
  fi
fi

# --- Part 2: Save failure state for success-after-failure detection ---
DATA_DIR="${CLAUDE_PLUGIN_DATA:-${HOME}/.openlore/state}"
mkdir -p "$DATA_DIR"

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
ERROR=$(echo "$INPUT" | jq -r '.error // .tool_response // ""' | head -c 2000)

if [ -n "$COMMAND" ] && [ -n "$ERROR" ]; then
  BASE_CMD=$(echo "$COMMAND" | awk '{print $1, $2}')
  jq -n \
    --arg cmd "$COMMAND" \
    --arg base "$BASE_CMD" \
    --arg err "$ERROR" \
    --arg ts "$(date +%s)" \
    '{command: $cmd, base_command: $base, error: $err, timestamp: ($ts | tonumber)}' \
    > "$DATA_DIR/last_failure.json"
fi

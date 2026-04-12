#!/usr/bin/env bash
# PostToolUseFailure handler: query OpenLore + save failure state.
# Combines extract-error.sh + save-failure.sh into one script
# to avoid stdin/matcher issues with multiple hook entries.

INPUT=$(cat)

# Pick first non-empty of .error / .tool_response. Plain `//` only falls back
# on null, not on empty strings — Claude Code sometimes sends "" for .error.
ERROR=$(echo "$INPUT" | jq -r '[.error, .tool_response] | map(select(. != null and . != "")) | .[0] // ""' | head -c 2000)

# --- Part 1: Query OpenLore for known fixes ---
if command -v openlore-mcp &>/dev/null; then
  if [ -n "$ERROR" ]; then
    openlore-mcp query "$ERROR" --json 2>/dev/null
  fi
fi

# --- Part 2: Save failure state for success-after-failure detection ---
DATA_DIR="${CLAUDE_PLUGIN_DATA:-${HOME}/.openlore/state}"
mkdir -p "$DATA_DIR"
STATE_FILE="$DATA_DIR/last_failure.json"

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

if [ -n "$COMMAND" ] && [ -n "$ERROR" ]; then
  BASE_CMD=$(echo "$COMMAND" | awk '{print $1, $2}')
  NOW=$(date +%s)

  # Preserve original failure trail: if state is live (<600s) and from a
  # different base command, keep it so the real fix can still match.
  if [ -f "$STATE_FILE" ]; then
    EXISTING_BASE=$(jq -r '.base_command // ""' "$STATE_FILE")
    EXISTING_TS=$(jq -r '.timestamp // 0' "$STATE_FILE")
    AGE=$(( NOW - EXISTING_TS ))
    if [ "$AGE" -lt 600 ] && [ "$EXISTING_BASE" != "$BASE_CMD" ]; then
      exit 0
    fi
  fi

  jq -n \
    --arg cmd "$COMMAND" \
    --arg base "$BASE_CMD" \
    --arg err "$ERROR" \
    --arg ts "$NOW" \
    '{command: $cmd, base_command: $base, error: $err, timestamp: ($ts | tonumber)}' \
    > "$STATE_FILE"
fi

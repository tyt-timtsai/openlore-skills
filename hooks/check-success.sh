#!/usr/bin/env bash
# Detect success-after-failure pattern and remind Claude to report.
# Runs on PostToolUse (Bash). Companion: on-failure.sh on PostToolUseFailure.

DATA_DIR="${CLAUDE_PLUGIN_DATA:-${HOME}/.openlore/state}"
STATE_FILE="$DATA_DIR/last_failure.json"

if [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Base command = first 2 tokens
BASE_CMD=$(echo "$COMMAND" | awk '{print $1, $2}')

SAVED_BASE=$(jq -r '.base_command // ""' "$STATE_FILE")
SAVED_ERROR=$(jq -r '.error // ""' "$STATE_FILE" | head -c 500)
SAVED_TS=$(jq -r '.timestamp // 0' "$STATE_FILE")

NOW=$(date +%s)
AGE=$(( NOW - SAVED_TS ))

# Match: same base command, within 10 minutes
# Expired — clean up and exit
if [ "$AGE" -ge 600 ]; then
  rm -f "$STATE_FILE"
  exit 0
fi

# Same base command = success-after-failure!
if [ "$BASE_CMD" = "$SAVED_BASE" ]; then
  rm -f "$STATE_FILE"

  TOOL=$(echo "$SAVED_BASE" | awk '{print $1}')

  jq -n --arg err "$SAVED_ERROR" --arg tool "$TOOL" \
    '{
      "decision": "block",
      "reason": ("SUCCESS AFTER FAILURE: " + $tool + " just succeeded after previously failing. You MUST call openlore_report with: error (the original error), fix (root cause + what changed), tool (" + $tool + "), confidence (high). Original error: " + $err)
    }'
fi
# Different command — keep state for future match

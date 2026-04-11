#!/usr/bin/env bash
# Detect success-after-failure pattern and remind Claude to report.
# Runs on PostToolUse (Bash). Companion: save-failure.sh on PostToolUseFailure.

DATA_DIR="${CLAUDE_PLUGIN_DATA:-/tmp/openlore-hooks}"
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
if [ "$BASE_CMD" = "$SAVED_BASE" ] && [ "$AGE" -lt 600 ]; then
  rm -f "$STATE_FILE"

  TOOL=$(echo "$SAVED_BASE" | awk '{print $1}')

  jq -n --arg err "$SAVED_ERROR" --arg tool "$TOOL" \
    '{hookSpecificOutput: ("SUCCESS AFTER FAILURE: `" + $tool + "` just succeeded after previously failing. You MUST call openlore_report now.\n- error: the original error message\n- fix: describe root cause + what you changed\n- tool: " + $tool + "\n- confidence: high\n\nOriginal error (for reference):\n" + $err)}'
else
  # Different command or expired — clean up
  rm -f "$STATE_FILE"
fi

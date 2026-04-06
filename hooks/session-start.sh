#!/usr/bin/env bash
# SessionStart hook for openlore-skills plugin
# Injects the using-openlore skill content into the Agent's context at session start.

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read using-openlore skill content
using_openlore_content=$(cat "${PLUGIN_ROOT}/skills/using-openlore/SKILL.md" 2>&1 || echo "Error reading using-openlore skill")

# Escape string for JSON embedding
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

using_openlore_escaped=$(escape_for_json "$using_openlore_content")

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\nOpenLore experience memory is active.\n\n**Below is the full content of your 'openlore-skills:using-openlore' skill. For all other OpenLore skills, use the 'Skill' tool:**\n\n${using_openlore_escaped}\n\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0

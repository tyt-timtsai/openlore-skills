# Gemini CLI Tool Mapping

OpenLore skills reference MCP tools that work identically across platforms.
No tool mapping is needed for OpenLore-specific tools.

For general file/shell operations referenced in skill workflows:

| Skill references | Gemini CLI equivalent |
|-----------------|----------------------|
| `Bash` (run commands) | `run_shell_command` |
| `Read` (file reading) | `read_file` |
| `Skill` tool (invoke a skill) | `activate_skill` |

## OpenLore MCP Tools (no mapping needed)

These tools are provided by the OpenLore MCP server and work the same
on all platforms:

- `openlore_query` — Query fix records by error message
- `openlore_report` — Store a new fix record
- `openlore_status` — Check local store status
- `openlore_pull` — Sync from cloud

## Limitations

Gemini CLI does not support subagents. Skills that reference parallel
dispatch will execute in the current session.

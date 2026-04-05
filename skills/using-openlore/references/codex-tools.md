# Codex Tool Mapping

OpenLore skills reference MCP tools that work identically across platforms.
No tool mapping is needed for OpenLore-specific tools.

For general file/shell operations referenced in skill workflows:

| Skill references | Codex equivalent |
|-----------------|------------------|
| `Bash` (run commands) | Use your native shell tools |
| `Read` (file reading) | Use your native file tools |
| `Skill` tool (invoke a skill) | Skills load natively — follow the instructions |

## OpenLore MCP Tools (no mapping needed)

These tools are provided by the OpenLore MCP server and work the same
on all platforms:

- `openlore_query` — Query fix records by error message
- `openlore_report` — Store a new fix record
- `openlore_status` — Check local store status
- `openlore_pull` — Sync from cloud

## Multi-Agent Support

If Codex supports `spawn_agent`, the `agents/error-analyst.md` prompt
can be used for deep error analysis. Configure in `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
```

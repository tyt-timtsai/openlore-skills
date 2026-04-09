@./skills/using-openlore/SKILL.md
@./skills/using-openlore/references/gemini-tools.md

# OpenLore Skills for Gemini CLI

OpenLore is an experience memory system. The skills above teach you to query
past fix records before debugging and report new fixes after resolving.

## Available Skills

When you encounter errors or bugs, activate the appropriate skill:

- `error-recovery` — For crashes, stack traces, build failures, HTTP errors
- `pattern-check` — For test failures, wrong output, unexpected behavior
- `knowledge-commit` — After successfully fixing a non-trivial bug

## OpenLore MCP Tools

These tools are provided by the OpenLore MCP server:

- `openlore_query(error_message, tool?, language?)` — Query fix records
- `openlore_report(error, fix, tool, confidence?)` — Store a new fix record
- `openlore_status()` — Check local store status
- `openlore_pull(include_public?)` — Sync from cloud

## The Rule

**Always query OpenLore before attempting your own fix.** Even if the error
looks simple. The query takes 2 seconds. A wrong guess wastes minutes.

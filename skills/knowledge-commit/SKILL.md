---
name: knowledge-commit
description: Use after fixing any bug or error — compilation failures, test failures, runtime errors, dependency issues, configuration problems, or environment quirks. If you just made something work that was broken, use this skill to store the fix. The bar is low: if the fix wasn't a single-character typo, report it.
---

# OpenLore Knowledge Commit

## Overview

You just fixed a bug. Store the fix so your future self — and other developers'
agents — can find it instantly instead of re-debugging from scratch.

This is how the experience memory grows. Every commit makes the next debugging
session faster.

## When to Use

Use this skill when ANY of these apply:
- You fixed a compilation error, build failure, or type error
- You fixed a test failure
- You resolved a runtime exception or crash
- A dependency or environment quirk caused the issue
- The fix involved a non-obvious root cause
- The error message was misleading about the actual cause
- You learned something not in the official docs

**The bar is intentionally low.** When in doubt, report it. A slightly
redundant record is better than a lost fix.

## When NOT to Use

Skip this skill when:
- The fix was a simple typo (missing semicolon, wrong variable name)
- You reverted an accidental change you just made
- The fix is purely project-specific config (file paths, env vars unique to one machine)
- The fix involves sensitive data (credentials, internal URLs, private API keys)

## Workflow

### Step 1: Summarize

Prepare three fields:

**error** — The original error message or symptom description. Use the same text
you would pass to `openlore_query`. Be specific enough that someone encountering
the same error would match on it.

**fix** — A 1-2 sentence description of what fixed it AND why. Include the root
cause, not just the solution.

Good examples:
- "rusqlite bundled feature requires a C compiler. Install Xcode CLT or add
  `brew install cmake` to the build environment."
- "pytest fixture scope mismatch: session-scoped fixture cannot depend on
  function-scoped fixture. Change the dependency to session scope."
- "axum handler returning 200 with empty body because `.json()` was called
  on a struct that doesn't derive Serialize. Add `#[derive(Serialize)]`."

Bad examples:
- "Fixed the build error." (no root cause)
- "Changed line 42." (no context)
- "It works now." (no information)

**tool** — The tool or framework that produced the error (e.g., `cargo`, `pytest`,
`npm`, `webpack`, `docker`).

### Step 2: Report

```
openlore_report(
  error="<original error>",
  fix="<root cause + solution>",
  tool="<tool name>",
  confidence="high"  // use "high" if verified with tests, "medium" if verified manually
)
```

### Step 3: Confirm

The MCP tool will respond with a confirmation message including the record ID.
Verify the response indicates successful storage. Done.

If the response indicates an error (e.g., store failed), inform the user but
do not retry — the fix is already applied, the report is best-effort.

---
name: openlore-pattern-check
description: Use when tests fail with assertion errors, output is wrong or empty, behavior is unexpected, API returns 200 but data is missing, "it doesn't work" or "something is wrong", you have tried multiple fixes without success, or the agent is going in circles
---

# OpenLore Pattern Check

## Overview

Not all errors produce stack traces. Sometimes tests fail with wrong values,
APIs return empty results, or things just "don't work." These are harder to
debug because there is no clear error message to search for.

OpenLore can still help — it stores patterns of common pitfalls and logic
errors, not just crash signatures.

<HARD-RULE>
If you have attempted 2+ fixes for the same issue without success, you MUST
query OpenLore before attempting another fix. Going in circles without
consulting the experience memory is a waste of time.
</HARD-RULE>

## Workflow

### Step 1: Extract

This is the key difference from `openlore-error-recovery`. Instead of extracting
a stack trace, you need to describe the symptom:

**For test assertion failures:**
- error_message: The assertion error (e.g., "Expected 5 but got 0",
  "AssertionError: array length should be 3")
- tool: The test runner (e.g., `pytest`, `vitest`, `jest`, `cargo test`)

**For wrong/empty output:**
- error_message: Describe the gap (e.g., "API returns empty array instead of
  user list", "function returns null instead of computed value")
- tool: The framework or runtime (e.g., `express`, `axum`, `django`)

**For "it doesn't work" / unclear symptoms:**
- error_message: Be specific about what you observe vs what you expect
  (e.g., "login button click does nothing, expected redirect to dashboard")
- tool: The relevant framework or tool

**For repeated failed attempts:**
- error_message: Summarize the original error AND what you have tried
  (e.g., "TypeError persists after adding null check and type guard")
- tool: Same as original

### Step 2: Query

```
openlore_query(error_message="<symptom description>", tool="<tool>")
```

### Step 3: Evaluate

Same as `openlore-error-recovery` Step 3. Apply high/medium confidence results,
use low confidence as hints, proceed manually only if no results.

### Step 4: Verify

Same as `openlore-error-recovery` Step 4. Re-run the failing test or reproduce
the scenario to confirm the fix works.

### Step 5: Report

If resolved, invoke `openlore-knowledge-commit`. Pattern-based fixes are
especially valuable to store — they are exactly the kind of knowledge that
LLM training data often lacks.

## When This Skill Triggers Automatically

This skill should be invoked proactively in these situations:

- You are on your 3rd attempt fixing the same issue
- A test fails and you are not sure why
- The user says something is "weird", "broken", "not working"
- An API call succeeds (200 OK) but the result is wrong
- You notice you are repeating a similar fix pattern

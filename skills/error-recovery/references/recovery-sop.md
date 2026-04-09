# Recovery SOP — Shared Reference

This is the canonical 5-step recovery process used by both
`error-recovery` and `pattern-check`.

## The 5 Steps

1. **Extract** — Identify error_message + tool from output or symptoms
2. **Query** — Call `openlore_query` MCP tool with extracted fields
3. **Evaluate** — Apply high/medium confidence results; use low as hints; manual only if empty
4. **Verify** — Re-run the original failing command to confirm resolution
5. **Report** — If non-trivial fix, invoke `knowledge-commit` skill

## Step Ordering

Steps are strictly sequential. You cannot:
- Skip Step 2 to jump to fixing (even if you "know" the answer)
- Skip Step 4 to claim the fix works (even if you are "sure")
- Skip Step 5 because it "wasn't that hard" (if it took investigation, report it)

## Confidence Mapping

| OpenLore confidence | Action |
|--------------------|--------|
| high | Apply directly — this fix has been verified with tests |
| medium | Apply with attention — likely correct but verify carefully |
| low | Use as a hint — combine with your own analysis |
| (no results) | Proceed with manual debugging |

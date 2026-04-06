# Audit Codebase

Run parallel audit subagents to check: $ARGUMENTS

If no args, audit everything. Otherwise scope to: security, frontend, backend, db, infra, performance, accessibility, data-integrity.

Run each audit in a forked subagent context so only final results appear in the main conversation. This keeps intermediate file reads out of your context window.

Dispatch these audits in parallel using background subagents:

1. **Security audit** — launch code-reviewer subagent (Sonnet)
   - Scope: files changed since main, or all files if $ARGUMENTS specifies
   - Check: OWASP top 10, hardcoded secrets, injection, auth bypass
   - Output: severity-rated findings with file:line references

2. **Frontend audit** — launch frontend-builder subagent (Sonnet)
   - Scope: frontend directories (src/components/, src/pages/, apps/web/, etc.)
   - Check: accessibility, responsive design, performance, design system compliance
   - Output: severity-rated findings

3. **Backend audit** — launch backend-builder subagent (Sonnet)
   - Scope: server directories (src/api/, apps/api/, server/, etc.)
   - Check: SQL injection, auth bypass, missing validation, error handling
   - Output: severity-rated findings

Wait for all subagents to complete, then synthesize into a single report:

```
## Audit Report — [date]
### Critical (must fix before merge)
### High (fix this sprint)
### Medium (fix soon)
### Low (nice to have)
```

Keep the synthesized report under 30 lines. Create `docs/` directory if needed, then save to `docs/audit-report.md` (overwrite if exists).

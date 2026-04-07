# Audit Codebase

Run parallel audit subagents to check: $ARGUMENTS

If no args, audit everything. Otherwise scope to: security, frontend, backend, db, infra, performance, accessibility, data-integrity.

Run each audit in a forked subagent context so only final results appear in the main conversation.

Dispatch in parallel:

1. **Security audit** — code-reviewer subagent (Sonnet)
   - Scope: files changed since main, or all files if $ARGUMENTS specifies
   - Check: OWASP top 10, hardcoded secrets, injection, auth bypass
   - Output: severity-rated findings with file:line

2. **Frontend audit** — frontend-builder subagent (Sonnet)
   - Scope: frontend directories
   - Check: accessibility, responsive, performance, design system compliance

3. **Backend audit** — backend-builder subagent (Sonnet)
   - Scope: server directories
   - Check: SQL injection, auth bypass, missing validation, error handling

Synthesize into a single report:

```
## Audit — YYYY-MM-DD
### Critical (must fix before merge)
### High (fix this sprint)
### Medium (fix soon)
### Low (nice to have)
```

Keep under 30 lines. Create `docs/audits/` if needed. Save to `docs/audits/audit_YYYY-MM-DD.md`.

If an audit for today already exists, overwrite it.

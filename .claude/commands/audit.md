# Audit Codebase

Run parallel audit subagents (Sonnet) to check: $ARGUMENTS

If no args, audit everything. Otherwise scope to: security, frontend, backend, db, infra, performance, accessibility, data-integrity.

Launch one Sonnet subagent per scope requested. Each subagent:
1. Reads the relevant files in its scope
2. Reports findings with severity (CRITICAL/HIGH/MEDIUM/LOW)
3. Includes file:line for each finding
4. Suggests fix

When all subagents complete, consolidate findings into a single prioritized report at `docs/audit-report-YYYY-MM-DD.md` (or update `docs/audit-report.md` if it exists).

Format: severity table + detailed findings. Group by module.

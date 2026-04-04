# Regenerate Architecture Review

<!-- TEMPLATE: Customize the doc paths below for your project. -->

Read the latest dated handoff and regenerate `docs/architecture-review.md` from scratch.

**Do NOT read the existing stale `docs/architecture-review.md`.**

Steps:
1. Read the latest dated handoff file from memory (MEMORY.md has the pointer)
2. Read in order (small, focused context):
   - `CLAUDE.md` (auto-loaded)
   - `docs/architecture.md` (stable blueprint)
   - `docs/<your-project>-map.md` (module specs and current status)
   - `docs/audit-report.md` (audit findings, if present)
   - Any memory files referenced in the handoff
3. Write a NEW `docs/architecture-review.md` covering:
   - Module boundaries and integration contracts
   - PR fix plan for audit findings
   - Migration paths for any planned architecture changes
   - Component rebuild plans (if any)
   - Priority order for implementation
4. Commit with a clear message noting this is a clean regeneration

**Source of truth priority (if conflicts arise):**
1. `docs/<your-project>-map.md` — most recent, most detailed
2. `CLAUDE.md` — stack decisions
3. `MEMORY.md` + memory files — decisions and context
4. `docs/architecture.md` — stable blueprint
5. `docs/audit-report.md` — original audit findings

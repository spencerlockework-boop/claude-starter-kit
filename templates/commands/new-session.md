# Orient Fresh Session

<!-- TEMPLATE: Customize the file paths in step 5 for your project. -->

This is a fresh session. Orient yourself quickly:

## 1. Project context
- `CLAUDE.md` is auto-loaded — you already have the project's stack, architecture, and conventions.

## 2. Session history (skip if first session)
- If `MEMORY.md` exists in the memory directory, read the index and the latest dated handoff.
- If no memory or handoff files exist yet, that's fine — this is a fresh project.

## 3. Git state
- Run `git log --oneline -10` to see recent work.
- Run `git status` to see uncommitted changes.

## 4. Work tracking
- Check `docs/FEATURES.md` if it exists (mirror of GitHub Issues).

## 5. Available toolkit
This project uses the **Claude Code Starter Kit**. You have:

**Slash commands** (run these inside the session):
- `/plan-feature <name>` — break a feature into agent-assigned tasks
- `/spec <name>` — write a module spec
- `/audit [scope]` — parallel security/frontend/backend audits (forked context)
- `/review` — review recent changes via subagents
- `/cleanup` — find dead files, duplicates, bloat
- `/handoff` — save session state to memory (use when context fills ~70%)
- `/sync-status` — quick 10-line status report
- `/regen-arch` — regenerate architecture review from current state
- `/test` — run test suite and summarize

**Subagents** (delegated work in isolated context):
- `frontend-builder` (Sonnet) — UI components, pages, styling
- `backend-builder` (Sonnet) — API routes, DB schema, server logic
- `code-reviewer` (Sonnet) — review code, no write access
- `architect` (Opus) — architecture decisions, design docs (output to conversation)
- `Explore` (built-in) — codebase search and file discovery

**Shell scripts** (run outside Claude to save tokens):
- `bash scripts/doctor.sh` — health-check environment
- `bash scripts/refresh-docs.sh` — sync features + backup memory
- `bash scripts/update-external-skills.sh` — fetch latest skills from upstream
- `bash scripts/lint-refs.sh` — catch stale cross-file references

**GitHub integration** (if configured):
- Issue templates: `feature.yml` and `bug.yml` with agent-assignment fields
- PR auto-review: `claude-review.yml` workflow (reads CLAUDE.md for context)
- Nightly cleanup: `nightly-cleanup.yml` (finds dead files, opens issues)
- Sync issues to local: `bash scripts/sync-features-from-issues.sh`
- Bulk create issues: `bash scripts/push-to-issues.sh <file.tsv>`

## Report (5 lines or less)
- What was last worked on
- What's next (from latest handoff, or "fresh project — awaiting instructions")
- Any uncommitted changes or blockers
- Current branch

Do NOT start implementing anything. Wait for instructions.

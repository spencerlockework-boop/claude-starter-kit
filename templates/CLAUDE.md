# Project — Claude Code Instructions

> **New to Claude Code?** Read `docs/how-claude-code-works.md` first — it explains the context window, subagents, tokens, and why the workflow below matters.

## What This Is
[One paragraph describing what the project does and who uses it.]

## Tech Stack

| Layer | Technology | Location |
|-------|-----------|----------|
| Frontend | [e.g., Next.js 15 + React 19] | apps/web/ |
| API | [e.g., Fastify + TypeScript] | apps/api/ |
| Database | [e.g., PostgreSQL + Drizzle] | packages/db/ |
| Shared types | TypeScript | packages/shared/ |

## Architecture Rules
- [Key constraint 1]
- [Key constraint 2]
- [Data ownership rules]
- [Security/auth principles]

## Design System (if applicable)
- Colors: [your palette]
- Typography: [font stack, sizes]
- Components: [radius, shadows, transitions]
- Explicitly avoid: [anti-patterns]

## File Organization
- `apps/api/` — API routes, middleware
- `apps/web/` — frontend pages, components
- `packages/db/` — schema, migrations
- `packages/shared/` — shared types
- `.claude/` — Claude Code config (agents, commands, skills)
- `docs/` — architecture, plans, specs
- `scripts/` — kit scripts + your own scripts

## Agent Workflow

This project uses the **Claude Code Starter Kit** — a multi-agent system with specialized subagents, slash commands, and automated workflows.

**How it works:**
- **Opus** (main session): orchestrates, delegates, makes architecture calls
- **Sonnet** (subagents): does the bulk work in isolated context windows — cheaper and doesn't fill your main context
- Subagents read this file (CLAUDE.md) for project-specific rules

**Model tiers** (cost vs capability):
- Opus = most capable, expensive — use for architecture, complex refactors, main session
- Sonnet = fast, cheap, good at routine code — use for subagents (set via `CLAUDE_CODE_SUBAGENT_MODEL`)

## Subagent Routing

| Task type | Route to |
|-----------|----------|
| Build UI component | `frontend-builder` (Sonnet) |
| Build API route, DB schema | `backend-builder` (Sonnet) |
| Architecture decision | `architect` (Opus) — output to conversation |
| Code review | `code-reviewer` (Sonnet) |
| File exploration | `Explore` subagent (built-in) |
| Parallel audits | `/audit` — multiple Sonnet subagents |

## Slash Commands

| Command | When to use |
|---------|-------------|
| `/new-session` | First thing every new session — orients and shows available tools |
| `/plan-feature <name>` | Before building anything non-trivial |
| `/spec <name>` | Before implementing a new module |
| `/audit [scope]` | Before PRs, periodically |
| `/review` | Before committing |
| `/test` | After implementing, before committing |
| `/cleanup` | Weekly maintenance |
| `/handoff` | When context is ~70% full |
| `/sync-status` | Quick check-in |
| `/regen-arch` | After audits or big refactors |

## GitHub Integration

This project has standardized GitHub workflows:
- **Issue templates**: `feature.yml` and `bug.yml` with area labels and agent-assignment fields
- **PR auto-review**: Claude reviews every PR using this file for context (`.github/workflows/claude-review.yml`)
- **Nightly cleanup**: Daily audit for dead files, stubs, build artifacts (`.github/workflows/nightly-cleanup.yml`)
- **Feature sync**: `bash scripts/sync-features-from-issues.sh` mirrors Issues to `docs/FEATURES.md`
- **Bulk issue creation**: `bash scripts/push-to-issues.sh <file.tsv>`

## Shell Scripts (no Claude tokens)

Run these yourself — don't burn tokens asking Claude:

| Script | What it does |
|--------|-------------|
| `bash scripts/doctor.sh` | Health-check environment |
| `bash scripts/refresh-docs.sh` | Sync features + backup memory + clean .DS_Store |
| `bash scripts/update-external-skills.sh` | Fetch latest skills from upstream repos |
| `bash scripts/lint-refs.sh` | Catch stale cross-file references |
| `bash scripts/backup-memory.sh` | Backup memory to `docs/memory-backup/` |

## Conventions
- Naming: [kebab-case files, PascalCase components, camelCase hooks, etc.]
- Commits: [conventional commits format if used]
- PRs: [your PR template rules]

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

For full details see `docs/tech.md` (created via `/plan project`).

## Architecture Rules
- [Key constraint 1]
- [Key constraint 2]
- [Data ownership rules]
- [Security/auth principles]

For full design see `docs/architecture.md` (created via `/plan project`).

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
- `docs/` — project docs, handoffs, audits
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
| Architecture decision | `architect` (Opus — output to conversation) |
| Code review | `code-reviewer` (Sonnet) |
| File exploration | `Explore` subagent (built-in) |
| Parallel audits | `/audit` — multiple Sonnet subagents |

## Commands

| Command | When to use |
|---------|-------------|
| `/orient` | Start of every session — reads project docs, handoff, shows available tools |
| `/plan project` | First time setup — creates tech.md, architecture.md, map.md |
| `/plan feature <name>` | Before building anything non-trivial |
| `/plan module <name>` | Before implementing a new module |
| `/audit [scope]` | Before PRs, periodically |
| `/review` | Before committing |
| `/test` | After implementing, before committing |
| `/cleanup` | Weekly maintenance |
| `/handoff` | When context is ~70% full — saves to docs/handoffs/ + memory |
| `/sync-status` | Quick check-in |
| `/pickup` | Pick next GitHub issue |
| `/debug` | Something broke — help figure out why |

## Project Docs

Created via `/plan project`, these are the source of truth:

| Doc | What it is |
|-----|-----------|
| `docs/tech.md` | Stack, tools, dependencies, dev setup |
| `docs/architecture.md` | System design, constraints, data flow |
| `docs/map.md` | Module specs, status, what's built vs planned |

Session output goes to organized folders:
- `docs/handoffs/` — session continuity (dated files)
- `docs/audits/` — audit history (dated files)

## GitHub Integration

- **Issue templates**: `feature.yml` and `bug.yml` with area labels and agent-assignment fields
- **PR auto-review**: Claude reviews every PR using this file for context
- **Nightly cleanup**: Daily audit for dead files, stubs, build artifacts
- **Feature sync**: `bash scripts/sync-features-from-issues.sh`

## Shell Scripts (no Claude tokens)

| Script | What it does |
|--------|-------------|
| `bash scripts/doctor.sh` | Health-check environment |
| `bash scripts/refresh-docs.sh` | Sync features + backup memory |
| `bash scripts/update-external-skills.sh` | Fetch latest skills from upstream |
| `bash scripts/lint-refs.sh` | Catch stale cross-file references |

## Conventions
- Naming: [kebab-case files, PascalCase components, camelCase hooks, etc.]
- Commits: [conventional commits format if used]
- PRs: [your PR template rules]

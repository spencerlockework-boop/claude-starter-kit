# Project — Claude Code Instructions

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
- `.claude/` — Claude Code config
- `docs/` — architecture, plans, specs

## Agent Workflow
- **Opus** (main session): PM, architecture, delegation
- **Sonnet subagents**: frontend-builder, backend-builder, code-reviewer
- Use `/clear` between unrelated features
- Use subagents for file exploration
- One major feature per session

## Subagent Routing Rules

| Task type | Route to |
|-----------|----------|
| Build UI component | `frontend-builder` (Sonnet) |
| Build API route, DB schema | `backend-builder` (Sonnet) |
| Architecture decision | `architect` (Opus) |
| Code review | `/codex:review` > `code-reviewer` (Sonnet) |
| File exploration | `Explore` subagent |
| Parallel audits | Multiple Sonnet subagents |

## Slash Commands
- `/new-session` — orient fresh session
- `/plan-feature <name>` — break feature into tasks
- `/spec <name>` — write module spec
- `/sync-status` — brief status report
- `/audit [scope]` — parallel audit subagents
- `/review` — review recent changes
- `/cleanup` — find duplicates, dead files, bloat
- `/handoff` — save dated session state
- `/pickup` — read GitHub issues, pick next task

## Conventions
- Naming: [kebab-case files, PascalCase components, camelCase hooks, etc.]
- Commits: [conventional commits format if used]
- PRs: [your PR template rules]

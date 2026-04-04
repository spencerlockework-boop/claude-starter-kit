# Claude Code Starter Kit

A reusable multi-agent setup for Claude Code projects. Drop this into any repo and you get: specialized subagents, slash commands, hygiene hooks, memory backup, and token-saving workflows.

## What's in here

```
.claude/
  agents/          Universal subagents (frontend-builder, backend-builder, code-reviewer, architect)
  commands/        Universal slash commands (handoff, sync-status, cleanup, audit, review)
  settings.json    Deny rules (rm -rf, force push, .env reads) + prettier hook
scripts/
  init-claude-system.sh    Installs this kit into any repo
  backup-memory.sh         Git-independent memory backup
  export-features-db.sh    Generate features.json from your map doc
docs/
  CHEAT-SHEET.md           All commands, aliases, prompts
  how-claude-code-works.md Under-the-hood guide
  module-spec-template.md  Template for speccing new modules
templates/
  CLAUDE.md                Starter template to customize per project
  commands/                Project-specific command templates
```

## Quick install into a new repo

```bash
bash /path/to/claude-starter-kit/scripts/init-claude-system.sh
```

Then edit `CLAUDE.md` with your project's stack and architecture.

## What's universal vs what you customize

**Universal (copied as-is):**
- Agents — generic instructions that read CLAUDE.md for project specifics
- Commands — `/handoff`, `/sync-status`, `/cleanup`, `/audit`, `/review`
- Settings — deny rules and prettier hook
- Scripts — init, backup, export

**Project-specific (customize from templates):**
- `CLAUDE.md` — your project's architecture
- `/new-session`, `/plan-feature`, `/spec`, `/pickup` — reference your paths

## How the system works

See `docs/how-claude-code-works.md` for the mental model and `docs/CHEAT-SHEET.md` for every command.

## Environment variables

Add to `~/.zshrc`:

```bash
export CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6
```

Makes subagents default to Sonnet, saving Opus tokens.

## Plugins to install

```bash
claude plugin marketplace add openai/codex-plugin-cc
claude plugin install codex@openai-codex
```

Then use `/codex:review` for code reviews = zero Claude tokens.

## License

MIT — use it however you like.

# Claude Code Starter Kit

A reusable multi-agent setup for Claude Code. Drop this into any repo and you get: specialized subagents, slash commands, hygiene hooks, memory backup, and token-saving workflows.

---

## Install into a new repo

From GitHub (no local clone needed):

```bash
cd /path/to/your-project
curl -s https://raw.githubusercontent.com/spencerlockework-boop/claude-starter-kit/main/scripts/init-from-github.sh | bash
```

Or from a local clone:

```bash
bash /path/to/claude-starter-kit/scripts/init-claude-system.sh
```

Then edit `CLAUDE.md` with your project's stack and architecture.

## Sync updates into an existing repo

From GitHub (always gets latest):

```bash
cd /path/to/your-project
curl -s https://raw.githubusercontent.com/spencerlockework-boop/claude-starter-kit/main/scripts/sync-from-github.sh | bash
```

Or from a local clone:

```bash
bash /path/to/claude-starter-kit/scripts/sync-from-kit.sh
```

Sync updates universal files only (agents, universal commands, skills, settings, scripts, docs). Never touches your project-specific files (CLAUDE.md, custom commands).

---

## What's in here

```
.claude/
  agents/          Universal subagents: frontend-builder, backend-builder, code-reviewer, architect
  commands/        Universal slash commands: handoff, sync-status, cleanup, audit, review
  skills/          Design system guidance (frontend-design, ui-ux-design, uncodixify-rules, project-manager-readme)
  settings.json    Deny rules (rm -rf, force push, .env reads) + prettier hook
scripts/
  init-claude-system.sh       Install this kit into any repo (local)
  init-from-github.sh         Install from GitHub with curl | bash
  sync-from-kit.sh            Pull latest universal files into a project (local)
  sync-from-github.sh         Sync from GitHub (always latest)
  uninstall.sh                Remove kit files (keeps your project files)
  backup-memory.sh            Git-independent memory backup
  sync-features-from-issues.sh  Pull GitHub Issues → docs/FEATURES.md + features.json
  refresh-docs.sh             Run all automated doc updates (features, memory, cleanup)
docs/
  how-claude-code-works.md Mental model and token management
  module-spec-template.md  Template for speccing new modules
templates/
  CLAUDE.md                Starter template to customize per project
  commands/                Project-specific command templates (new-session, plan-feature, spec)
  .gitignore               Common ignores + Claude Code specifics (worktrees, local settings)
  .github/
    workflows/             claude-review.yml (PR auto-review) + nightly-cleanup.yml (daily audit)
    ISSUE_TEMPLATE/        feature.yml + bug.yml with agent-assignment fields
```

When you run `init-claude-system.sh`, it copies all universal files into your repo AND installs the template `.github/` workflows and `.gitignore` (only if they don't already exist). The uninstall script reverses this.

---

## Slash Commands (run inside a Claude session)

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/new-session` | Orient in a fresh session (reads CLAUDE.md + handoff, 5-line status) | First thing every new session |
| `/plan-feature <name>` | Break feature into tasks, assign agents, identify dependencies | Before building anything non-trivial |
| `/spec <name>` | Write a module spec into your map doc | Before implementing a new module |
| `/sync-status` | 10-line status report (branch, commits, dirty files, next action) | Quick check-in |
| `/audit [scope]` | Parallel Sonnet audit subagents (security, frontend, backend, db, infra, performance, accessibility, data-integrity) | Before PRs, periodically |
| `/review` | Review recent changes via subagents | Before committing |
| `/cleanup` | Find duplicates, dead files, stubs, bloat | Weekly maintenance |
| `/handoff` | Save dated session state to memory | When context is ~70% full |
| `/pickup [issue#]` | Read GitHub issues, pick next task | Start of new session |
| `/codex:review` | Delegate review to OpenAI Codex (if plugin installed) | Instead of `/review` to save tokens |

---

## Shell Aliases (add to `~/.zshrc`)

```bash
alias cc="claude"                   # start interactive session
alias ccq="claude -p"               # one-shot prompt, no session
alias ccr="claude --resume"         # resume last session
alias ccheat="less $HOME/Documents/Claude-Code-Repos/claude-starter-kit/README.md"
```

---

## Scripts

| Script | What it does |
|--------|-------------|
| `bash scripts/init-claude-system.sh [target]` | Install kit into another repo (from local clone) |
| `bash scripts/init-from-github.sh [target]` | Install from GitHub (no local clone needed) |
| `bash scripts/sync-from-kit.sh [target]` | Pull latest universal files into a project (from local clone) |
| `bash scripts/sync-from-github.sh [target]` | Sync from GitHub (always gets latest main) |
| `bash scripts/uninstall.sh [target]` | Remove kit files from a repo (keeps your project files) |
| `bash scripts/backup-memory.sh` | Backup memory files to `docs/memory-backup/` |
| `bash scripts/sync-features-from-issues.sh` | Pull GitHub Issues into `docs/FEATURES.md` + `docs/features.json` |
| `bash scripts/refresh-docs.sh` | One-command doc refresh (features + memory + cleanup) |

---

## What You Can Do Without Claude

Run these yourself — don't burn tokens asking me:

```bash
# Git status + recent commits
git status --short && git log --oneline -5

# Find stub files (under 5 lines)
find docs -name "*.md" -type f -exec wc -l {} \; | sort -n | head -10

# List dated handoffs
ls ~/.claude/projects/*/memory/handoff_*.md

# Find duplicate markdown files
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" \
  -exec md5sum {} \; | sort | uniq -d -w32

# Clean .DS_Store
find . -name ".DS_Store" -not -path "./node_modules/*" -delete
```

---

## Subagent Routing

| Task | Who |
|------|-----|
| UI component, page, styling | `frontend-builder` (Sonnet) |
| API route, DB schema, query hook | `backend-builder` (Sonnet) |
| Architecture decision | `architect` (Opus) |
| Code review | `/codex:review` > `code-reviewer` (Sonnet) |
| Explore codebase / find files | `Explore` subagent |
| Parallel audits | `/audit` launches N Sonnet subagents |
| Cross-module refactor | Main session (Opus) |

---

## Context Savers

| Instead of | Do this |
|-----------|---------|
| "Read all the files and tell me what's there" | `/sync-status` or `ls` yourself |
| "What did we do last session?" | Read handoff yourself |
| "Check if X is still true" | grep it yourself before asking |
| "Do a big review" | `/audit security` or `/codex:review` |
| Long explanations | Ask "one-liner:" or "in 3 bullets:" |

---

## Environment Variables

Add to `~/.zshrc`:

```bash
export CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6
```

Subagents default to Sonnet, saving Opus tokens.

---

## Install the Codex Plugin

```bash
claude plugin marketplace add openai/codex-plugin-cc
claude plugin install codex@openai-codex
```

Then `/codex:review` offloads code review to OpenAI = zero Claude tokens.

---

## What's Automated

Runs WITHOUT you asking:

| What | When |
|------|------|
| Prettier auto-format | After any Edit/Write on code files (via settings.json hook) |
| Deny rule enforcement | Every Bash/Read call |
| CLAUDE.md + MEMORY.md load | Every new session |
| Subagents default to Sonnet | Every subagent spawn |

## What You Run Manually

| Task | Command |
|------|---------|
| Back up memory to git | `bash scripts/backup-memory.sh` |
| Refresh features.json | `bash scripts/export-features-db.sh` |
| Sync kit updates | `bash scripts/sync-from-kit.sh` |
| Commit + push | `git commit` / `git push` |

## What Claude Runs (ask it)

| Task | Command |
|------|---------|
| Audit codebase | `/audit [scope]` |
| Review changes | `/review` or `/codex:review` |
| Plan feature | `/plan-feature <name>` |
| Write spec | `/spec <name>` |
| Clean dead files | `/cleanup` |
| Save session | `/handoff` |
| Next issue | `/pickup` |

---

## Token-Saving Prompts

Instead of: "Can you review all the code and tell me if there are issues?"
Try: "One-liner review: any bugs in [file]?"

Instead of: "Search the codebase for auth handlers"
Try: "Use Explore subagent to find auth handlers"

Instead of: "Explain what this function does"
Try: "2-sentence purpose of X function"

Instead of: "What's the best approach for Y?"
Try: "Short answer: A or B, why?"

---

## Keep Claude Short

Start a session with one of these:
- "Keep responses under 3 sentences unless I ask for detail"
- "Don't explain, just do"
- "No preamble, no summary, just the code"
- "If you need to explore, use subagents"

---

## Separation of Concerns

This kit is developer tooling that lives **alongside** your app code, not part of it:

**App code** (stays as-is):
- `apps/`, `packages/`, `infra/`, `src/` — whatever your stack uses
- Your app's own docs in `docs/` (architecture.md, domain-model.md, etc.)

**Claude Code system** (this kit):
- `.claude/` — agents, commands, skills, settings
- `CLAUDE.md` — project brain (the one file that bridges both)
- `scripts/` — kit scripts alongside your own scripts

**Working docs** (project-specific, created by Claude sessions):
- `docs/<your-project>-map.md` — module specs and status
- `docs/architecture-review.md` — architecture decisions
- `docs/audit-report.md` — audit findings
- `docs/FEATURES.md` — mirror of GitHub Issues
- `docs/features.json` — machine-readable feature snapshot

**Work tracking:**
- **GitHub Issues** are the source of truth for backlog/bugs/features
- `docs/FEATURES.md` is a local mirror, regenerate with `sync-features-from-issues.sh`

**What to commit vs. gitignore:**
- Commit: `.claude/`, `CLAUDE.md`, `.github/workflows/`, all docs
- Gitignore: `.claude/worktrees/`, `.claude/settings.local.json`
- Team preference: `docs/memory-backup/` (personal decision history) and `docs/features.json` (derived)

## License

MIT — use it however you like.

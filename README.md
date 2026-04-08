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

**Forked the kit?** Override the default GitHub URL:

```bash
export CLAUDE_KIT_REPO=https://github.com/your-org/claude-starter-kit.git
```

Both `init-from-github.sh` and `sync-from-github.sh` respect this env var.

---

## What's in here

```
.claude/
  agents/          Universal subagents: frontend-builder, backend-builder, code-reviewer, architect
  commands/        Universal: orient, plan, handoff, audit, review, test, cleanup, sync-status, pickup, debug
  skills/          Skill folders (design, UI rules, brand refs, browser automation + synced external)
  settings.json    Deny rules (rm -rf, force push, .env reads) + prettier hook
skills.json        External skill manifest (upstream sources + plugin registry)
scripts/
  init-claude-system.sh         Install this kit into any repo (local)
  init-from-github.sh           Install from GitHub with curl | bash
  sync-from-kit.sh              Pull latest universal files into a project (local)
  sync-from-github.sh           Sync from GitHub (always latest)
  uninstall.sh                  Remove kit files (keeps your project files)
  backup-memory.sh              Git-independent memory backup
  restore-memory.sh             Restore memory from docs/memory-backup/ (fresh machine)
  sync-features-from-issues.sh  Pull GitHub Issues → docs/FEATURES.md + features.json
  push-to-issues.sh             Bulk create GitHub Issues from TSV file
  refresh-docs.sh               Run all automated doc updates (features, memory, cleanup)
  doctor.sh                     Health-check Claude Code environment
  update-external-skills.sh     Sync file-based skills from upstream repos
  install-plugins.sh            Print plugin install commands for Claude Code session
  lint-refs.sh                  Check for stale cross-file references
docs/
  how-claude-code-works.md Mental model and token management
  POST-IT.md               Printable quick-reference card
templates/
  CLAUDE.md                Starter template to customize per project
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
| `/orient` | Read project docs + handoff, show status and available tools | Start of every session |
| `/plan project` | Create `docs/tech.md`, `docs/architecture.md`, `docs/map.md` interactively | First time setup |
| `/plan feature <name>` | Break feature into agent-assigned tasks | Before building anything non-trivial |
| `/plan module <name>` | Write a module spec into `docs/map.md` | Before implementing a new module |
| `/audit [scope]` | Parallel forked subagents (security, frontend, backend) → `docs/audits/` | Before PRs, periodically |
| `/review` | Review recent changes via subagents | Before committing |
| `/test` | Run test suite, summarize pass/fail | After implementing |
| `/cleanup` | Find dead files, stubs, stale worktrees, bloat | Weekly maintenance |
| `/handoff` | Save session state to `docs/handoffs/` + memory dir | When context is ~70% full |
| `/sync-status` | 10-line status report | Quick check-in |
| `/pickup [issue#]` | Read GitHub issues, pick next task | Start of new session |
| `/debug` | Diagnose what broke — reads errors, recent changes, suggests fix | Something is broken |

---

## Shell Aliases (add to `~/.zshrc`)

```bash
alias cc="claude"                   # start interactive session
alias ccq="claude -p"               # one-shot prompt, no session
alias ccr="claude --resume"         # resume last session
alias ccheat="less /path/to/claude-starter-kit/README.md"  # adjust path
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
| `bash scripts/restore-memory.sh` | Restore memory from `docs/memory-backup/` (fresh machine) |
| `bash scripts/sync-features-from-issues.sh` | Pull GitHub Issues → `docs/FEATURES.md` + `docs/features.json` |
| `bash scripts/push-to-issues.sh <file.tsv>` | Bulk create GitHub Issues from TSV (title, body, labels, assignee) |
| `bash scripts/refresh-docs.sh` | One-command doc refresh (features + memory + cleanup) |
| `bash scripts/doctor.sh` | Health-check Claude Code environment |
| `bash scripts/update-external-skills.sh` | Sync file-based skills from upstream repos |
| `bash scripts/install-plugins.sh` | Print plugin install commands for Claude Code session |
| `bash scripts/lint-refs.sh` | Check for stale cross-file references |

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
  -exec md5 -r {} \; | sort | uniq -d -w32

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
| Explore codebase / find files | `Explore` subagent (built-in, not a kit file) |
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

| What | When | Where |
|------|------|-------|
| Prettier auto-format | After any Edit/Write on code files | `.claude/settings.json` hook |
| Deny rule enforcement | Every Bash/Read call | `.claude/settings.json` |
| CLAUDE.md + MEMORY.md load | Every new session | Claude Code built-in |
| Subagents default to Sonnet | Every subagent spawn | `CLAUDE_CODE_SUBAGENT_MODEL` env var |
| Nightly cleanup audit | 7am UTC daily | `.github/workflows/nightly-cleanup.yml` |
| Claude PR review | Every PR (reads CLAUDE.md for context, needs `ANTHROPIC_API_KEY` secret) | `.github/workflows/claude-review.yml` |

## What You Run Manually

No Claude tokens used:

| Task | Command |
|------|---------|
| Refresh all derived docs | `bash scripts/refresh-docs.sh` |
| Sync features from GitHub Issues | `bash scripts/sync-features-from-issues.sh` |
| Back up memory to git | `bash scripts/backup-memory.sh` |
| Sync starter kit updates | `bash scripts/sync-from-kit.sh` or `sync-from-github.sh` |
| Update external skills | `bash scripts/update-external-skills.sh` |
| Install plugin skills | `bash scripts/install-plugins.sh` (prints commands to paste) |
| Health-check environment | `bash scripts/doctor.sh` |
| Check for stale refs | `bash scripts/lint-refs.sh` |
| Commit + push | `git commit` / `git push` |

## What Claude Runs (ask it)

Uses Claude tokens:

| Task | Command |
|------|---------|
| Orient session | `/orient` |
| Setup project docs | `/plan project` |
| Plan a feature | `/plan feature <name>` |
| Plan a module | `/plan module <name>` |
| Audit codebase | `/audit [scope]` |
| Review changes | `/review` |
| Run tests | `/test` |
| Debug an issue | `/debug <error>` |
| Clean dead files | `/cleanup` |
| Save session state | `/handoff` |
| Next GitHub issue | `/pickup` |
| Quick status | `/sync-status` |

## External (no Claude tokens)

| Task | Command |
|------|---------|
| Code review via OpenAI Codex | `/codex:review` |
| Adversarial review | `/codex:adversarial-review` |
| Delegate investigation/fix | `/codex:rescue` |

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

## After Install

1. Run `claude` then `/orient` — it will tell you project docs are missing
2. Run `/plan project` — creates `docs/tech.md`, `docs/architecture.md`, `docs/map.md` interactively
3. Edit `CLAUDE.md` with your stack and conventions

**All commands are universal** — no customization needed. They read your project docs to understand context.

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
- `docs/architecture.md` — **stable reference**: the system as it is (4-plane model, stack, constraints). Changes rarely.
- `docs/map.md` — module specs, status, what's built vs planned. Update with `/plan module`.
- `docs/handoffs/` — dated session handoffs. Written by `/handoff`.
- `docs/audits/` — dated audit reports. Written by `/audit`.
- `docs/FEATURES.md` — mirror of GitHub Issues. Regenerate with `sync-features-from-issues.sh`.

### Document flow

```
/plan project creates:
  docs/tech.md          ← stack, tools, dependencies
  docs/architecture.md  ← system design, constraints
  docs/map.md           ← module specs + status
       ↓
  Claude reads all three + CLAUDE.md
       ↓
  /plan feature → task list → build → /audit → GitHub Issues
       ↓
  docs/FEATURES.md  ← mirror of GitHub Issues
```

| Doc | Source | When to update |
|-----|--------|----------------|
| `docs/tech.md` | `/plan project` or manual | When stack changes |
| `docs/architecture.md` | `/plan project` or manual | When design changes |
| `docs/map.md` | `/plan module` | Every time you add/change a module |
| `docs/handoffs/` | `/handoff` | End of each session |
| `docs/audits/` | `/audit` | Before PRs, periodically |
| `FEATURES.md` | `bash scripts/sync-features-from-issues.sh` | After GitHub Issues change |

**Work tracking:**
- **GitHub Issues** are the source of truth for backlog/bugs/features
- `docs/FEATURES.md` is a local mirror, regenerate with `sync-features-from-issues.sh`

**What to commit vs. gitignore:**
- Commit: `.claude/`, `CLAUDE.md`, `skills.json`, `.github/workflows/`, all docs
- Gitignore: `.claude/worktrees/`, `.claude/settings.local.json`
- Team preference: `docs/memory-backup/` (personal decision history) and `docs/features.json` (derived)

## External Skills

Skills are pulled from upstream repos and tracked in `skills.json`:

| Skill | Source | Type |
|-------|--------|------|
| ui-ux-design | Local (ships with kit) | Local |
| uncodixify-rules | [cyxzdev/Uncodixfy](https://github.com/cyxzdev/Uncodixfy) | File sync |
| frontend-design | [anthropics/claude-code](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design) | File sync / Plugin |
| obsidian-markdown | [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) | File sync |
| claude-mem-do | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | File sync |
| playwright-cli | [microsoft/playwright-cli](https://github.com/microsoft/playwright-cli) | File sync |
| brand-design | [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) | Local (9 brands) |
| frontend-design refs | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | Local (7 reference docs) |
| PM + Engineering skills | [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | Plugin |
| Code review, feature-dev, PR review, security, hookify | [anthropics/claude-code](https://github.com/anthropics/claude-code) | Plugin |

### Update file-synced skills

```bash
bash scripts/update-external-skills.sh
```

### Install plugin-based skills

```bash
bash scripts/install-plugins.sh
```

Then paste the output into your Claude Code session.

### Add a new external skill

Edit `skills.json` and add an entry:

```json
{
  "my-new-skill": {
    "source": "https://raw.githubusercontent.com/owner/repo/main/SKILL.md",
    "repo": "https://github.com/owner/repo",
    "description": "What it does",
    "type": "single-file",
    "lastSync": ""
  }
}
```

Then run `bash scripts/update-external-skills.sh`.

---

## License

MIT — use it however you like.

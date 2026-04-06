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
  commands/        Universal slash commands: handoff, sync-status, cleanup, audit, review
  skills/          Skill folders (frontend-design, ui-ux-design, uncodixify-rules + synced external skills)
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
  module-spec-template.md  Template for speccing new modules
templates/
  CLAUDE.md                Starter template to customize per project
  BOOTSTRAP.md             Fresh-machine setup guide (clone → install → run)
  commands/                Project-specific command templates (new-session, plan-feature, spec, regen-arch)
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
| `/audit [scope]` | Parallel forked Sonnet subagents (security, frontend, backend) — results only in main context | Before PRs, periodically |
| `/review` | Review recent changes via subagents | Before committing |
| `/test` | Run test suite, summarize pass/fail | After implementing, before committing |
| `/cleanup` | Find duplicates, dead files, stubs, bloat | Weekly maintenance |
| `/handoff` | Save dated session state to memory | When context is ~70% full |
| `/pickup [issue#]` | Read GitHub issues, pick next task *(optional — create yourself)* | Start of new session |
| `/codex:review` | Delegate review to OpenAI Codex (if plugin installed) | Instead of `/review` to save tokens |

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
| Orient fresh session | `/new-session` |
| Plan a feature | `/plan-feature <name>` |
| Write a module spec | `/spec <name>` |
| Audit codebase | `/audit [scope]` |
| Review changes | `/review` |
| Run tests | `/test` |
| Clean dead files | `/cleanup` |
| Save session state | `/handoff` |
| Regenerate architecture review | `/regen-arch` |
| Next GitHub issue | `/pickup` *(optional — create yourself)* |
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

## After Install — Customize These

When you install the kit, 4 commands get copied as **templates** — they reference project paths that differ per project. Edit them once when you first set up your repo:

| File | What to customize |
|------|-------------------|
| `.claude/commands/new-session.md` | Path to your map doc (e.g. `docs/myapp-map.md`) |
| `.claude/commands/plan-feature.md` | Your directory paths (e.g. `src/api/`, `src/web/`) |
| `.claude/commands/spec.md` | Your map doc name |
| `.claude/commands/regen-arch.md` | Your map doc name |

Look for HTML comment headers (`<!-- TEMPLATE: ... -->`) and `<placeholder>` values.

**Universal commands** (no customization — they work in any repo):
- `/handoff`, `/sync-status`, `/cleanup`, `/audit`, `/review`, `/test`

**Optional**: Create a `/pickup` command that hits your GitHub repo:
```bash
# .claude/commands/pickup.md
Read GitHub issues from <your-org>/<your-repo>, sort by label priority, pick up the next unassigned one.
```

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
- `docs/architecture-review.md` — **point-in-time analysis**: what's broken + PR plan to fix it. Regenerated periodically.
- `docs/<your-project>-map.md` — module specs, status, field schemas. Updated with every module spec change.
- `docs/audit-report.md` — audit findings (security, perf, design, etc.). Regenerate with `/audit`.
- `docs/FEATURES.md` — mirror of GitHub Issues. Regenerate with `sync-features-from-issues.sh`.
- `docs/features.json` — machine-readable feature snapshot. Regenerated alongside FEATURES.md.

### Document flow

Docs build on each other in a chain:

```
architecture.md  ← human-written: the blueprint
       +
<project>-map.md  ← human-written: module specs + status
       ↓
   (Claude reads both)
       ↓
architecture-review.md  ← Claude-generated: analysis + PR plan
       ↓
   (fix plan becomes GitHub Issues)
       ↓
FEATURES.md + features.json  ← mirror of GitHub Issues
```

| Doc | Source | When to update |
|-----|--------|----------------|
| `architecture.md` | You write it | Only when architecture actually changes |
| `<project>-map.md` | You write it (use `/spec`) | Every time you add/change a module |
| `architecture-review.md` | **Claude generates it** from the two above | Regenerate after audits or big refactors — in a fresh session for clean context |
| GitHub Issues | Created from review's fix plan | Continuous — filed as work items |
| `FEATURES.md` + `features.json` | Auto-generated from GitHub Issues | `bash scripts/sync-features-from-issues.sh` |

**The rule:** upstream changes invalidate downstream docs. If you change `architecture.md` or the map, regenerate `architecture-review.md`. If the review's fix plan changes, update the issues.

If you only have one architecture doc, use `architecture.md`. `architecture-review.md` is optional — only create it when you want Claude's analysis + PR plan for a big refactor.

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
| entrepreneur-mvp | [slavingia/skills](https://github.com/slavingia/skills) | File sync |
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

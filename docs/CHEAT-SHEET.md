# Claude Code Cheat Sheet — SourceVault

Everything you can do without burning Claude tokens. Print this, tape it to your monitor.

---

## Slash Commands (run inside a claude session)

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/new-session` | Orient in a fresh session (reads CLAUDE.md + handoff, reports 5-line status) | First thing in every new session |
| `/plan-feature <name>` | Break feature into tasks, assign agents, identify dependencies | Before building anything non-trivial |
| `/spec <name>` | Write a module spec into sourcevault-map.md | Before implementing a new module |
| `/sync-status` | 10-line status report (branch, commits, dirty files, next action) | Quick check-in |
| `/audit [scope]` | Parallel Sonnet audit subagents. Scopes: security, frontend, backend, db, infra, performance, accessibility, data-integrity | Before PRs, periodically |
| `/review` | Review recent changes via subagents | Before committing |
| `/cleanup` | Find duplicates, dead files, stubs, bloat | Weekly maintenance |
| `/handoff` | Save dated session state to memory | When context is ~70% full |
| `/pickup [issue#]` | Read GitHub issues, pick next task | Start of new session |
| `/codex:review` | Delegate review to OpenAI Codex (if plugin installed) | Instead of `/review` to save tokens |

---

## Shell Aliases (add to ~/.zshrc)

```bash
# Claude Code shortcuts
alias cc="claude"                                    # start interactive session
alias ccq="claude -p"                                # one-shot prompt, no session
alias cnew="claude -p 'Read CLAUDE.md and handoff_latest. Report status in 5 lines.'"
alias cstatus='echo "--- git ---" && git status --short && echo "--- commits ---" && git log --oneline -5'
alias cclean="find . -name '.DS_Store' -not -path './node_modules/*' -delete && echo 'Cleaned'"
```

---

## Scripts (run from repo root)

| Script | What it does |
|--------|-------------|
| `bash scripts/init-claude-system.sh [target-dir]` | Install Claude system into another repo |
| `bash scripts/backup-memory.sh` | Backup memory files to docs/memory-backup/ (Git-independent) |
| `bash scripts/export-features-db.sh` | Generate docs/features.json (machine-readable module status) |

---

## What You Can Do Without Claude

Use these instead of asking me:

### Git status check
```bash
git status --short && git log --oneline -5
```

### Find stale files
```bash
find docs -name "*.md" -type f -exec wc -l {} \; | sort -n | head -10
```

### Count handoffs
```bash
ls ~/.claude/projects/-your-project-slug/memory/handoff_*.md
```

### Check for duplicates
```bash
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" -exec md5sum {} \; | sort | uniq -d -w32
```

### See what's in .claude/
```bash
ls .claude/agents/ && ls .claude/commands/
```

### Test a command without opening a session
```bash
claude -p "/sync-status"
```

---

## Subagent Routing (when to delegate)

| Task | Who |
|------|-----|
| UI component, page, styling | `frontend-builder` (Sonnet subagent) |
| API route, DB schema, query hook | `backend-builder` (Sonnet subagent) |
| Architecture decision | `architect` (Opus subagent) |
| Code review | `/codex:review` > `code-reviewer` (Sonnet) |
| Explore codebase / find files | `Explore` subagent |
| Parallel audits | `/audit` launches N Sonnet subagents |
| Cross-module refactor | Main session (Opus) |

---

## Context Savers

| Instead of | Do this |
|-----------|---------|
| "Read all the files and tell me what's there" | `/sync-status` or `ls -la` yourself |
| "What did we do last session?" | Read `~/.claude/projects/.../memory/handoff_latest.md` yourself |
| "Check if X is still true" | grep it yourself before asking |
| "Do a big review" | `/audit security` or `/codex:review` (parallel/external) |
| Long explanations | Ask "one-liner:" or "in 3 bullets:" |
| Re-reading CLAUDE.md | It's auto-loaded every session |

---

## Environment Variables

```bash
export CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6  # subagents default to Sonnet (saves Opus)
```

---

## Files You Should Know

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project brain, auto-loaded every session |
| `docs/FEATURES.md` | Quick module status tracker |
| `docs/features.json` | Machine-readable version |
| `docs/sourcevault-map.md` | Full module specs |
| `docs/CHEAT-SHEET.md` | This file |
| `docs/how-claude-code-works.md` | How the tool works under the hood |
| `docs/memory-backup/` | Git-persisted memory backup |
| `~/.claude/projects/.../memory/MEMORY.md` | Index of all memory files (auto-loaded) |
| `~/.claude/projects/.../memory/handoff_YYYY-MM-DD.md` | Dated session handoffs |

---

## Token-Saving Prompts

Instead of: "Can you review all the code we just wrote and tell me if there are any issues?"
Try: "One-liner review: any bugs in [file]?"

Instead of: "Please search the codebase for places where we handle authentication"
Try: "Use Explore subagent to find auth handlers"

Instead of: "Explain what this function does in detail"
Try: "2-sentence purpose of X function"

Instead of: "What's the best approach for Y?"
Try: "Short answer: A or B, why?"

---

## Keep Me Short

Tell me at the start of a session:
- "Keep responses under 3 sentences unless I ask for detail"
- "Don't explain, just do"
- "No preamble, no summary, just the code"
- "If you need to explore, use subagents"

---

## Starter Prompts (copy/paste these)

### Starting a fresh session
```
/new-session
```
That's it. The command reads CLAUDE.md + latest handoff + git state and reports 5-line status.

### Continuing yesterday's work
```
Read handoff_2026-04-04 and continue from "Critical Next Step"
```

### Adding a new feature
```
/plan-feature <feature name>
```
I'll break it into tasks with agent assignments. You approve, then I delegate.

### Writing a new module spec
```
/spec <module name>
```
I'll draft the spec into sourcevault-map.md using the template.

### Running audits (token-heavy)
```
/audit security
/audit frontend
/audit data-integrity
```
Each launches parallel Sonnet subagents. Use specific scopes to save tokens.

### Code review (cheap — uses Codex)
```
/codex:review
```
External OpenAI review. Zero Claude tokens.

### Quick status check
```
/sync-status
```
10-line report. Branch, commits, dirty files, next action.

### Saving before context fills
```
/handoff
```
Creates dated memory file. Next session reads it automatically.

### Cleaning up repo
```
/cleanup
```
Finds duplicates, stubs, bloat. Asks before deleting.

### Picking up GitHub issues
```
/pickup
```
Or `/pickup 42` to jump straight to issue #42.

---

## What's Automated (you don't need to ask)

These run WITHOUT you prompting Claude:

| What | When | Where |
|------|------|-------|
| Prettier auto-format | After any Edit/Write on .ts/.tsx/.js/.jsx | `.claude/settings.json` hook |
| Nightly repo audit | 7am UTC daily on GitHub | `.github/workflows/nightly-cleanup.yml` |
| Claude PR review | Every PR opened/updated | `.github/workflows/claude-review.yml` |
| CLAUDE.md + MEMORY.md load | Every new session | Auto-loaded by Claude Code |
| Deny rule enforcement | Every Bash/Read call | `.claude/settings.json` deny list |
| Subagents default to Sonnet | Every subagent spawn | `CLAUDE_CODE_SUBAGENT_MODEL` env var |

## What You Need to Run Manually

These you must trigger yourself:

| What | Command | How often |
|------|---------|-----------|
| Back up memory to git | `bash scripts/backup-memory.sh` | After significant memory changes |
| Refresh features.json | `bash scripts/export-features-db.sh` | After updating sourcevault-map status |
| Commit work | `git commit` (or ask me) | End of every session |
| Push to remote | `git push` | End of session, or when ready |
| Install into another repo | `bash scripts/init-claude-system.sh <target>` | When starting a new project |

## What Claude Can Run (if you ask)

These need Claude to invoke them — they're tools, not automation:

| Task | Ask me |
|------|--------|
| Audit the codebase | `/audit [scope]` |
| Review recent changes | `/review` or `/codex:review` |
| Plan a feature | `/plan-feature <name>` |
| Write a module spec | `/spec <name>` |
| Clean up dead files | `/cleanup` |
| Save session state | `/handoff` |
| Find the next issue to work on | `/pickup` |

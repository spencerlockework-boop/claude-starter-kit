# How Claude Code Actually Works — No BS Guide

## The Mental Model

Claude Code is a **stateless text model with a scratchpad (context window) and tools**.

Every interaction follows this loop:
```
You type → [your message + ALL prior context] → sent to Claude → Claude responds + maybe calls tools → tool results added to context → repeat
```

There is no persistent memory between turns except:
1. Files on disk (CLAUDE.md, memory files)
2. The conversation history (compressed when full)
3. Git state

**Claude does NOT remember anything between sessions.** Each new `claude` invocation starts fresh. It reads CLAUDE.md and memory files to reconstruct context.

---

## The Context Window

Think of it as a fixed-size whiteboard. Everything goes on it:

| What | Token Cost | Notes |
|------|-----------|-------|
| CLAUDE.md | ~800-2000 | Loaded every turn. Keep it lean. |
| Memory (MEMORY.md + files) | ~500-3000 | Loaded every turn |
| Your message | ~50-500 | Short prompts = more room for work |
| Claude's response | ~200-2000 | |
| **File reads** | **500-5000 each** | **This is what kills you** |
| Grep/search results | 200-1000 | |
| Bash output | 100-2000 | |
| Prior turns (history) | accumulates | Gets compressed when window fills |

**200K tokens ≈ 150K words ≈ about 500 pages of text.**

That sounds like a lot, but reading 15 source files + their tool results can eat 30-50K tokens in minutes.

### What "compression" means
When context fills up (~80%), Claude Code automatically summarizes older turns. This is **lossy** — specific line numbers, exact code snippets, and nuanced decisions get flattened into summaries. This is why long sessions degrade.

### How to protect context

| Action | Saves | When |
|--------|-------|------|
| `/clear` | Everything | Between unrelated tasks |
| `/compact` | ~40-60% | Mid-session when sluggish |
| Subagents | Their reads don't touch your window | File exploration, research |
| Short prompts | 10-100 tokens per message | Always |
| Specific file reads (offset/limit) | vs reading whole files | Large files |

---

## Tools — What Claude Can Actually Do

### Built-in Tools (always available)
```
Read     — read a file (with line offset/limit)
Write    — create a new file
Edit     — surgical find-and-replace in existing file
Glob     — find files by pattern (*.tsx, src/**/*.ts)
Grep     — search file contents (regex)
Bash     — run any shell command
Agent    — spawn a subagent (separate context window)
```

### What Subagents Are

A subagent is a **separate Claude instance** with its own context window.

```
Main Session (your conversation)
  │
  ├─ Agent(type=Explore, model=inherited)
  │    Has: Read, Grep, Glob, Bash (read-only)
  │    Does: finds files, searches code, reports back summary
  │    Cost: its own context (doesn't fill yours)
  │
  ├─ Agent(type=general-purpose, model=sonnet)
  │    Has: ALL tools including Write/Edit
  │    Does: builds code, runs tests, reports back
  │    Cost: cheaper (Sonnet) + isolated context
  │
  └─ Agent(type=Plan)
       Has: Read, Grep, Glob (no writing)
       Does: designs implementation plans
       Cost: isolated context
```

**Key insight**: when I use a subagent, its file reads and tool calls do NOT appear in our conversation. Only its final summary comes back. This is the #1 way to save context.

### Custom Agents (.claude/agents/)

These are markdown files that configure specialized subagents:
```yaml
---
name: frontend-builder
model: sonnet          # cheaper, faster, good at routine code
tools: [Read, Write, Edit, Glob, Grep, Bash]
---
Instructions for what this agent knows and does...
```

The starter kit ships with these:
- `frontend-builder` (Sonnet) — UI components
- `backend-builder` (Sonnet) — API routes, DB schema
- `code-reviewer` (Sonnet) — reviews, no write access
- `architect` (Opus) — system design

### Worktrees

A worktree = a full git branch checkout in a separate directory + a separate Claude session.

```bash
# Terminal 1
claude --worktree upload-flow
# Working on branch worktree-upload-flow
# Full isolated context window

# Terminal 2
claude --worktree notifications
# Working on branch worktree-notifications
# Completely independent
```

Changes from each worktree can be merged back via normal git.

---

## What Claude Reads at Session Start

Every time you run `claude`, before you type anything, it loads:

1. **CLAUDE.md** (project root) — project instructions
2. **~/.claude/CLAUDE.md** (user global) — your personal preferences
3. **Memory files** (MEMORY.md index + referenced .md files)
4. **.claude/settings.json** — tool permissions, hooks
5. **Git status** — current branch, recent commits, dirty files

This is your "free" context — it's loaded anyway. Make it count.

---

## The Optimal Workflow

### Bad (context-burning)
```
You: "Here's a big task with 8 subtasks, go build everything"
Claude: reads 15 files, builds 3 things, context fills up,
        quality degrades, forgets early decisions, makes mistakes
```

### Good (context-preserving)
```
You: "Build the vendor group filter for the asset table"
Claude: delegates file exploration to Explore subagent (isolated),
        gets summary back, builds the one feature, done.
You: /clear
You: "Now build the notification panel"
Claude: fresh context, reads only what's needed, builds it clean.
```

### Best (parallel)
```
Terminal 1: claude --worktree vendor-filter
Terminal 2: claude --worktree notifications
Terminal 3: claude --worktree temporal-setup
# Three features built simultaneously, zero context collision
```

---

## Commands You Should Know

| Command | What it does |
|---------|-------------|
| `/clear` | Wipe conversation, keep CLAUDE.md + memory |
| `/compact` | Summarize history, free ~40-60% context |
| `/cost` | Show token usage this session |
| `/memory` | View/manage memory files |
| `! command` | Run a shell command yourself in the session |
| `/help` | Full help |

---

## How to Give Good Prompts

### Wasteful
> "Can you look at the codebase and figure out what needs to be done for the upload flow and then build it?"

This triggers massive exploration (10+ file reads into context) before any work starts.

### Efficient
> "Build the metadata form component. It's a modal in <component-file>.tsx that opens after file selection. Needs: auto-generated codes (sequential pattern), editable fields (name/type/source), bulk edit bar, CSV export button. API endpoint already exists at GET /api/next-code."

This tells me exactly what to build, where it goes, and what already exists. I can start coding immediately with 1-2 targeted file reads.

### The pattern
1. **What** to build (specific feature)
2. **Where** it goes (file paths if you know them)
3. **What exists** (APIs, components to reuse)
4. **What it should look like** (behavior, not implementation)

---

## What Each Model Is Good At

| Model | Best for | Cost | Speed |
|-------|---------|------|-------|
| **Opus** | Architecture, complex refactors, multi-file changes, debugging hard bugs | $$$ | Slower |
| **Sonnet** | Routine code, single-file components, tests, migrations, simple features | $ | Fast |
| **Haiku** | Quick questions, formatting, simple edits | ¢ | Fastest |

The recommended setup: Opus as your main session, Sonnet for subagents. This balances capability with cost.

---

## Files That Matter

```
CLAUDE.md                    ← What every session reads first. Keep accurate.
.claude/agents/*.md          ← Your agent team definitions
.claude/settings.json        ← Project settings
.claude/settings.local.json  ← Your local permissions (not committed)
~/.claude/projects/.../memory/
  ├── MEMORY.md              ← Index of all memories (loaded every session)
  ├── reference_*.md         ← Where to find things
  ├── feedback_*.md          ← How you want to work
  ├── project_*.md           ← Project state and decisions
  └── user_*.md              ← About you
```

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| "Do everything in one session" | One feature per session, `/clear` between |
| Giant open-ended prompts | Specific: what, where, how |
| Letting Claude read 15 files | Use subagents for exploration |
| Not updating CLAUDE.md | Stale specs = wasted work |
| Amending when hooks fail | Always new commit after hook failure |
| Asking Claude to remember | Save to memory files explicitly |
| Long sessions without /compact | Compact when responses get vague |

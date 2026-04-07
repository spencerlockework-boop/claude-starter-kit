# Orient

Orient yourself in this project. Read the essential context, report status, and wait for instructions.

## 1. Project context
- `CLAUDE.md` is auto-loaded.
- Read `docs/tech.md` if it exists (stack, tools, dependencies).
- Read `docs/architecture.md` if it exists (system design, constraints).
- Read `docs/map.md` if it exists (module specs, status).
- If ANY of these three docs are missing, note which ones and suggest: "Run `/plan project` to set them up."

## 2. Session continuity
- Read `MEMORY.md` from the memory directory if it exists.
- Find the most recent file in `docs/handoffs/` (sorted by date in filename). Read it.
- If no handoff exists, that's fine — note "No prior handoff found."

## 3. Git state
- `git log --oneline -10`
- `git status`

## 4. Work tracking
- Read `docs/FEATURES.md` if it exists (GitHub Issues mirror).

## 5. Worktrees
- Check `.claude/worktrees/` for any existing worktree directories.
- If any exist, list them with their branch names.
- If a worktree's branch no longer exists in git, flag it as stale.

## 6. Available toolkit
This project uses the **Claude Code Starter Kit**:

**Commands:** `/plan`, `/orient`, `/audit`, `/review`, `/test`, `/cleanup`, `/handoff`, `/sync-status`, `/pickup`, `/debug`

**Agents:** `frontend-builder` (Sonnet), `backend-builder` (Sonnet), `code-reviewer` (Sonnet), `architect` (Opus — output only), `Explore` (built-in)

**Shell scripts (save tokens — run outside Claude):** `doctor.sh`, `refresh-docs.sh`, `update-external-skills.sh`, `lint-refs.sh`

## Report (5-10 lines)
- Project docs status (which of tech/architecture/map exist)
- What was last worked on (from handoff or recent commits)
- What's next (from handoff, or "awaiting instructions")
- Uncommitted changes or blockers
- Current branch
- Active worktrees (if any)

Do NOT start implementing anything. Wait for instructions.

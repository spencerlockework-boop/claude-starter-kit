# Repo Cleanup

Find and clean up bloat. Report findings before deleting anything.

Check for:
1. `.DS_Store` files anywhere in the repo
2. Build artifacts tracked in git (`*.tsbuildinfo`, `.next/`, `dist/`, `target/`)
3. Stale worktrees in `.claude/worktrees/` (branch no longer exists in git)
4. Empty directories (except build output dirs)
5. Duplicate markdown files (same content in different locations)
6. Stub files (files with only "TODO" or "404" or under 5 lines of content)
7. Root-level `.md` files that should be in `docs/`
8. Memory files referenced in MEMORY.md that don't exist
9. Memory files that exist but aren't in MEMORY.md index
10. Old handoffs in `docs/handoffs/` (older than 30 days — suggest archiving)
11. Old audits in `docs/audits/` (older than 30 days — suggest archiving)

Report as a table: file/dir, issue, recommended action (DELETE/MOVE/ARCHIVE/KEEP).

Ask for confirmation before deleting anything. After deletion, verify the git tree is clean and suggest a commit message.

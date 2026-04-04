# Session Handoff

Context is running low. Save everything the next session needs to continue seamlessly.

Steps:
1. Get today's date in YYYY-MM-DD format (from `/currentDate` context).
2. Look at what was accomplished this session (git diff, tasks completed).
3. Look at what's still in progress or planned.
4. Write a dated handoff memory file at `~/.claude/projects/-your-project-slug/memory/handoff_YYYY-MM-DD.md` with:
   - What was built/changed this session
   - What's still broken or incomplete
   - The exact next steps to pick up
   - Any decisions made that aren't in CLAUDE.md
   - File paths that were being worked on
5. Update MEMORY.md index:
   - Remove the old "Latest handoff" pointer
   - Add a new pointer to today's dated handoff as "Latest handoff"
   - Keep prior dated handoffs in the index (they're history — useful for tracking what was decided when)
6. If there's a dirty git state, suggest committing with a clear message.

Naming rule: ONE dated handoff per calendar day. If a handoff_YYYY-MM-DD.md already exists for today, append/update it instead of creating a new one.

The goal: the next session reads CLAUDE.md + MEMORY.md + the latest dated handoff and can immediately continue without re-exploring the codebase.

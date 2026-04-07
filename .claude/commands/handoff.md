# Session Handoff

Context is running low. Save everything the next session needs to continue seamlessly.

Steps:
1. Get today's date in YYYY-MM-DD format.
2. Look at what was accomplished this session (git diff, tasks completed).
3. Look at what's still in progress or planned.
4. Write a dated handoff file to BOTH locations:

   **a) Git-tracked (for team visibility and machine portability):**
   `docs/handoffs/handoff_YYYY-MM-DD.md`

   **b) Memory directory (so Claude auto-loads it next session):**
   `~/.claude/projects/<project-slug>/memory/handoff_YYYY-MM-DD.md`
   (where `<project-slug>` is the absolute path of the repo with `/` replaced by `-`)

5. Handoff content:
   - What was built/changed this session
   - What's still broken or incomplete
   - The exact next steps to pick up
   - Any decisions made that aren't in CLAUDE.md or docs/
   - File paths that were being worked on

6. Update MEMORY.md index in the memory directory:
   - Remove the old "Latest handoff" pointer
   - Add a new pointer to today's dated handoff as "Latest handoff"

7. If there's a dirty git state, suggest committing with a clear message.

Naming rule: ONE dated handoff per calendar day. If one already exists for today, append/update it instead of creating a new one.

The goal: next session runs `/orient`, reads CLAUDE.md + docs/ + the handoff, and can immediately continue.

# Pickup

Pick up the next task from GitHub Issues.

Steps:
1. Run `gh issue list --state open --limit 20 --json number,title,labels,assignees,updatedAt`
2. If that fails, check if `gh` CLI is installed and authenticated. If not, tell the user.
3. Filter and prioritize:
   - Unassigned issues first
   - Sort by label priority: `critical` > `high` > `bug` > `feature` > unlabeled
   - If $ARGUMENTS is a number, pick that specific issue instead
4. For the selected issue, read the full body: `gh issue view <number>`
5. Report:
   - Issue title and number
   - Description summary (2-3 lines)
   - Suggested agent routing (frontend-builder / backend-builder / architect)
   - Whether `docs/tech.md`, `docs/architecture.md`, `docs/map.md` have relevant context
6. Ask: "Start `/plan feature <issue-title>`?"

Do NOT start implementing. Wait for confirmation.

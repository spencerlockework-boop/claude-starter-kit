# Review Recent Changes

Review code changes with parallel subagents.

Steps:
1. Get changed files: `git diff main --name-only` (or `git diff HEAD~1` if on main)
2. Launch Sonnet subagents in parallel:
   - **code-reviewer** — security, design system, regressions, type safety
   - **architect** (only if schema or module boundaries changed) — architecture review
3. Consolidate findings into a single report
4. Group by severity and file

# Global Claude Code Preferences

<!-- This file lives at ~/.claude/CLAUDE.md and applies to ALL projects. -->
<!-- Project-specific instructions go in each repo's CLAUDE.md instead. -->

## Response Style
- Keep responses concise — no preamble, no trailing summaries
- Don't explain what you just did unless asked
- Use subagents for file exploration instead of reading everything into context

## Git Conventions
- Conventional commits (feat:, fix:, docs:, refactor:, test:, chore:)
- Never amend after a hook failure — always new commit
- Never force push to main/master

## Safety
- Never read .env files — check .env.example instead
- Never run destructive commands without confirmation
- Never skip pre-commit hooks

## Token Management
- One feature per session, `/clear` between unrelated tasks
- Use `/compact` when responses get vague
- Delegate file exploration to Explore subagents
- Use Sonnet subagents for routine code (set via CLAUDE_CODE_SUBAGENT_MODEL)

## Preferences
- Testing: always run tests after implementing, before committing
- Reviews: use subagent code-reviewer before committing
- Naming: [your preferred naming conventions]
- Language: [your preferred spoken language for responses]

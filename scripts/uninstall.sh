#!/bin/bash
# uninstall.sh
# Remove Claude Code starter kit files from a repo.
# Does NOT touch project files (CLAUDE.md, custom commands, memory, docs/sourcevault-map, etc.)
# Only removes kit-managed files.

set -e

TARGET="${1:-$(pwd)}"

echo "This will remove Claude Code starter kit files from: $TARGET"
echo ""
echo "Will remove:"
echo "  .claude/agents/{frontend-builder,backend-builder,code-reviewer,architect}.md"
echo "  .claude/commands/{handoff,sync-status,cleanup,audit,review}.md"
echo "  .claude/skills/ (entire directory)"
echo "  scripts/{backup-memory,export-features-db}.sh"
echo "  docs/how-claude-code-works.md"
echo "  docs/module-spec-template.md"
echo ""
echo "Will NOT touch:"
echo "  CLAUDE.md"
echo "  .claude/settings.json"
echo "  .claude/commands/{new-session,plan-feature,spec,pickup,implement}.md"
echo "  Any other project files"
echo ""
read -p "Continue? [y/N] " -n 1 -r
echo
[[ ! $REPLY =~ ^[Yy]$ ]] && { echo "Aborted."; exit 0; }

cd "$TARGET"

# Universal agents
rm -f .claude/agents/frontend-builder.md
rm -f .claude/agents/backend-builder.md
rm -f .claude/agents/code-reviewer.md
rm -f .claude/agents/architect.md

# Universal commands
rm -f .claude/commands/handoff.md
rm -f .claude/commands/sync-status.md
rm -f .claude/commands/cleanup.md
rm -f .claude/commands/audit.md
rm -f .claude/commands/review.md

# Skills
rm -rf .claude/skills

# Scripts
rm -f scripts/backup-memory.sh
rm -f scripts/export-features-db.sh

# Docs
rm -f docs/how-claude-code-works.md
rm -f docs/module-spec-template.md

# Clean empty dirs
rmdir .claude/agents 2>/dev/null || true
rmdir .claude/commands 2>/dev/null || true
rmdir scripts 2>/dev/null || true

echo "✓ Uninstalled. Your project files are untouched."

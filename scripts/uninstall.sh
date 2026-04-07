#!/bin/bash
# uninstall.sh
# Remove Claude Code starter kit files from a repo.
# Does NOT touch project files (CLAUDE.md, docs/tech.md, docs/architecture.md, docs/map.md, etc.)
# Only removes kit-managed files.

set -e

TARGET="${1:-$(pwd)}"

echo "This will remove Claude Code starter kit files from: $TARGET"
echo ""
echo "Will remove:"
echo "  .claude/agents/{frontend-builder,backend-builder,code-reviewer,architect}.md"
echo "  .claude/commands/{orient,plan,handoff,sync-status,cleanup,audit,review,test,pickup,debug}.md"
echo "  .claude/skills/ (entire directory)"
echo "  scripts/{backup-memory,restore-memory,sync-features-from-issues,push-to-issues,refresh-docs,doctor,uninstall,update-external-skills,install-plugins,lint-refs}.sh"
echo "  skills.json"
echo "  docs/how-claude-code-works.md"
echo "  docs/FEATURES.md, docs/handoffs/.gitkeep, docs/audits/.gitkeep"
echo "  .github/workflows/{claude-review,nightly-cleanup}.yml"
echo "  .github/ISSUE_TEMPLATE/{feature,bug}.yml"
echo ""
echo "Will NOT touch:"
echo "  CLAUDE.md"
echo "  .claude/settings.json"
echo "  docs/tech.md, docs/architecture.md, docs/map.md (your project docs)"
echo "  docs/handoffs/*.md, docs/audits/*.md (your session history)"
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
rm -f .claude/commands/orient.md
rm -f .claude/commands/plan.md
rm -f .claude/commands/handoff.md
rm -f .claude/commands/sync-status.md
rm -f .claude/commands/cleanup.md
rm -f .claude/commands/audit.md
rm -f .claude/commands/review.md
rm -f .claude/commands/test.md
rm -f .claude/commands/pickup.md
rm -f .claude/commands/debug.md

# Skills
rm -rf .claude/skills

# Scripts
rm -f scripts/backup-memory.sh
rm -f scripts/restore-memory.sh
rm -f scripts/sync-features-from-issues.sh
rm -f scripts/push-to-issues.sh
rm -f scripts/refresh-docs.sh
rm -f scripts/doctor.sh
rm -f scripts/uninstall.sh
rm -f scripts/update-external-skills.sh
rm -f scripts/install-plugins.sh
rm -f scripts/lint-refs.sh
rm -f skills.json

# Docs (kit-managed only — keeps user's project docs and handoff/audit content)
rm -f docs/how-claude-code-works.md
rm -f docs/FEATURES.md
rm -f docs/handoffs/.gitkeep
rm -f docs/audits/.gitkeep

# GitHub templates (installed by init)
rm -f .github/workflows/claude-review.yml
rm -f .github/workflows/nightly-cleanup.yml
rm -f .github/ISSUE_TEMPLATE/feature.yml
rm -f .github/ISSUE_TEMPLATE/bug.yml

# Clean empty dirs (only if empty — won't delete dirs with user content)
rmdir .claude/agents 2>/dev/null || true
rmdir .claude/commands 2>/dev/null || true
rmdir docs/handoffs 2>/dev/null || true
rmdir docs/audits 2>/dev/null || true
rmdir .github/workflows 2>/dev/null || true
rmdir .github/ISSUE_TEMPLATE 2>/dev/null || true
rmdir .github 2>/dev/null || true
rmdir scripts 2>/dev/null || true

echo "Uninstalled. Your project files (CLAUDE.md, tech.md, architecture.md, map.md, handoffs, audits) are untouched."

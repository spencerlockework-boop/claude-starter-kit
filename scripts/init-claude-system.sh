#!/bin/bash
# init-claude-system.sh
# Drops the Claude Code multi-agent system into any repo.
# Run from the target repo root: bash /path/to/init-claude-system.sh
#
# What it creates:
#   .claude/          (agents, commands, settings, hooks)
#   docs/             (FEATURES.md, how-claude-code-works.md, module-spec-template.md)
#   CLAUDE.md         (only if missing)
#   scripts/          (backup-memory.sh, export-features-db.sh)

set -e

# Source defaults to this starter kit's parent (the kit itself).
# Resolves to: /path/to/claude-starter-kit (parent of scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_REPO="${CLAUDE_SYSTEM_SOURCE:-$(dirname "$SCRIPT_DIR")}"
TARGET="${1:-$(pwd)}"

if [ ! -d "$SOURCE_REPO/.claude" ]; then
  echo "ERROR: Source repo not found at $SOURCE_REPO"
  echo "Set CLAUDE_SYSTEM_SOURCE env var or edit this script."
  exit 1
fi

# Prevent installing over itself
if [ "$(cd "$SOURCE_REPO" && pwd)" = "$(cd "$TARGET" && pwd)" ]; then
  echo "ERROR: Source and target are the same directory. Run from a different repo."
  exit 1
fi

echo "Installing Claude Code system from $SOURCE_REPO into $TARGET"
cd "$TARGET"

# 1. Create .claude structure
mkdir -p .claude/agents .claude/commands .claude/skills

# 2. Copy agents (universal)
cp "$SOURCE_REPO/.claude/agents/"*.md .claude/agents/ 2>/dev/null || true

# 3. Copy UNIVERSAL commands only (not project-specific)
# Project-specific commands (new-session, plan-feature, spec, pickup) reference
# SourceVault paths — users adapt those manually after install.
for cmd in handoff sync-status cleanup audit review; do
  [ -f "$SOURCE_REPO/.claude/commands/$cmd.md" ] && cp "$SOURCE_REPO/.claude/commands/$cmd.md" .claude/commands/
done

# Copy project-specific command TEMPLATES (user adapts them)
if [ -d "$SOURCE_REPO/templates/commands" ]; then
  for tmpl in "$SOURCE_REPO/templates/commands/"*.md; do
    name=$(basename "$tmpl")
    [ ! -f ".claude/commands/$name" ] && cp "$tmpl" ".claude/commands/$name"
  done
fi

echo "Note: project-specific commands installed as templates — customize paths for your stack."

# 4. Copy settings.json (deny rules + formatting hook)
if [ ! -f .claude/settings.json ]; then
  cp "$SOURCE_REPO/.claude/settings.json" .claude/settings.json
fi

# 5. Copy docs
mkdir -p docs
[ ! -f docs/how-claude-code-works.md ] && cp "$SOURCE_REPO/docs/how-claude-code-works.md" docs/ 2>/dev/null || true
[ ! -f docs/module-spec-template.md ] && cp "$SOURCE_REPO/docs/module-spec-template.md" docs/ 2>/dev/null || true

# 6. Copy scripts
mkdir -p scripts
cp "$SOURCE_REPO/scripts/backup-memory.sh" scripts/ 2>/dev/null || true
cp "$SOURCE_REPO/scripts/export-features-db.sh" scripts/ 2>/dev/null || true
chmod +x scripts/*.sh 2>/dev/null || true

# 6b. Copy .github templates (workflows, issue templates) if they don't exist
if [ -d "$SOURCE_REPO/templates/.github" ]; then
  mkdir -p .github/workflows .github/ISSUE_TEMPLATE
  for f in "$SOURCE_REPO/templates/.github/workflows/"*.yml; do
    name=$(basename "$f")
    [ ! -f ".github/workflows/$name" ] && cp "$f" ".github/workflows/$name"
  done
  for f in "$SOURCE_REPO/templates/.github/ISSUE_TEMPLATE/"*.yml; do
    name=$(basename "$f")
    [ ! -f ".github/ISSUE_TEMPLATE/$name" ] && cp "$f" ".github/ISSUE_TEMPLATE/$name"
  done
fi

# 6c. Merge .gitignore if doesn't have Claude Code entries
if [ -f "$SOURCE_REPO/templates/.gitignore" ]; then
  if [ ! -f .gitignore ]; then
    cp "$SOURCE_REPO/templates/.gitignore" .gitignore
  elif ! grep -q ".claude/worktrees" .gitignore; then
    echo "" >> .gitignore
    echo "# Added by claude-starter-kit" >> .gitignore
    echo ".claude/worktrees/" >> .gitignore
    echo ".claude/settings.local.json" >> .gitignore
  fi
fi

# 7. Create FEATURES.md if missing
if [ ! -f docs/FEATURES.md ]; then
  cat > docs/FEATURES.md << 'EOF'
# Feature Tracker

Status: 🔴 Not started | 🟡 In progress | 🟢 Complete | 🔵 In review | ⚫ Blocked

## Modules

| Module | Owner Agent | Status | Notes |
|--------|------------|--------|-------|
| (example) auth | backend-builder | 🔴 | Not started |

## Active Tasks

| Task | Agent | Status | PR/Branch |
|------|-------|--------|-----------|
| — | — | — | — |
EOF
fi

# 8. Create CLAUDE.md from template if missing
if [ ! -f CLAUDE.md ] && [ -f "$SOURCE_REPO/templates/CLAUDE.md" ]; then
  cp "$SOURCE_REPO/templates/CLAUDE.md" CLAUDE.md
fi

# 9. Environment variable recommendation
if ! grep -q "CLAUDE_CODE_SUBAGENT_MODEL" "$HOME/.zshrc" 2>/dev/null; then
  echo ""
  echo "RECOMMENDED: Add to your shell profile to run subagents on Sonnet:"
  echo "  export CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6"
  echo ""
fi

echo "✓ Installed .claude/agents ($(ls .claude/agents/ | wc -l | tr -d ' ') agents)"
echo "✓ Installed .claude/commands ($(ls .claude/commands/ | wc -l | tr -d ' ') commands)"
echo "✓ Installed .claude/settings.json (deny rules + format hook)"
echo "✓ Installed docs/ (FEATURES.md, how-claude-code-works.md, module-spec-template.md)"
echo "✓ Installed scripts/ (backup-memory.sh, export-features-db.sh)"
echo ""
echo "NEXT STEPS:"
echo "  1. Edit CLAUDE.md with your project's stack and architecture"
echo "  2. Customize .claude/agents/ for your domain"
echo "  3. Add project-specific slash commands to .claude/commands/"
echo "  4. Run 'claude' and type '/new-session' to orient"

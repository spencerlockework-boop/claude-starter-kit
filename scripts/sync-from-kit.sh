#!/bin/bash
# sync-from-kit.sh
# Pull latest universal Claude system files from the starter kit into this repo.
# Run from any target repo: bash /path/to/claude-starter-kit/scripts/sync-from-kit.sh
#
# What it updates (safe — only touches universal files):
#   .claude/agents/*.md (except project-specific customizations)
#   .claude/commands/{handoff,sync-status,cleanup,audit,review}.md
#   .claude/skills/*.md
#   .claude/settings.json (merged, not overwritten)
#   scripts/ (all kit-managed scripts)
#   docs/how-claude-code-works.md
#   docs/module-spec-template.md
#
# What it NEVER touches:
#   CLAUDE.md (project-specific)
#   .claude/commands/{new-session,plan-feature,spec,pickup}.md (project-specific)
#   docs/CHEAT-SHEET.md (project reference)
#   Any other project files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"
TARGET="${1:-$(pwd)}"

if [ "$(cd "$KIT_ROOT" && pwd)" = "$(cd "$TARGET" && pwd)" ]; then
  echo "ERROR: Can't sync the kit into itself."
  exit 1
fi

if [ ! -d "$TARGET/.claude" ]; then
  echo "ERROR: Target doesn't have .claude/ directory. Run init-claude-system.sh first."
  exit 1
fi

echo "Syncing from: $KIT_ROOT"
echo "      to:     $TARGET"
echo ""

UPDATED=0

# Sync universal agents (overwrite — they read CLAUDE.md for project specifics)
for f in "$KIT_ROOT/.claude/agents/"*.md; do
  name=$(basename "$f")
  if [ -f "$TARGET/.claude/agents/$name" ]; then
    if ! cmp -s "$f" "$TARGET/.claude/agents/$name"; then
      cp "$f" "$TARGET/.claude/agents/$name"
      echo "  updated: .claude/agents/$name"
      UPDATED=$((UPDATED+1))
    fi
  fi
done

# Sync universal commands
for cmd in orient plan handoff sync-status cleanup audit review test pickup debug; do
  src="$KIT_ROOT/.claude/commands/$cmd.md"
  dst="$TARGET/.claude/commands/$cmd.md"
  if [ -f "$src" ] && [ -f "$dst" ]; then
    if ! cmp -s "$src" "$dst"; then
      cp "$src" "$dst"
      echo "  updated: .claude/commands/$cmd.md"
      UPDATED=$((UPDATED+1))
    fi
  fi
done

# Sync skills (folder structure)
for skill_dir in "$KIT_ROOT/.claude/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  mkdir -p "$TARGET/.claude/skills/$skill_name"
  # Only sync SKILL.md (gotchas.md is user-maintained)
  src="$skill_dir/SKILL.md"
  dst="$TARGET/.claude/skills/$skill_name/SKILL.md"
  if [ -f "$src" ]; then
    if [ ! -f "$dst" ] || ! cmp -s "$src" "$dst"; then
      cp "$src" "$dst"
      echo "  updated: .claude/skills/$skill_name/SKILL.md"
      UPDATED=$((UPDATED+1))
    fi
  fi
done

# Sync scripts (except init-claude-system, init-from-github, sync-from-kit, sync-from-github — those are kit-only)
for script in backup-memory.sh restore-memory.sh sync-features-from-issues.sh push-to-issues.sh refresh-docs.sh doctor.sh uninstall.sh update-external-skills.sh install-plugins.sh lint-refs.sh; do
  src="$KIT_ROOT/scripts/$script"
  dst="$TARGET/scripts/$script"
  if [ -f "$src" ]; then
    mkdir -p "$TARGET/scripts"
    if [ ! -f "$dst" ] || ! cmp -s "$src" "$dst"; then
      cp "$src" "$dst"
      chmod +x "$dst"
      echo "  updated: scripts/$script"
      UPDATED=$((UPDATED+1))
    fi
  fi
done

# Sync universal docs
for doc in how-claude-code-works.md module-spec-template.md; do
  src="$KIT_ROOT/docs/$doc"
  dst="$TARGET/docs/$doc"
  if [ -f "$src" ]; then
    mkdir -p "$TARGET/docs"
    if [ ! -f "$dst" ] || ! cmp -s "$src" "$dst"; then
      cp "$src" "$dst"
      echo "  updated: docs/$doc"
      UPDATED=$((UPDATED+1))
    fi
  fi
done

echo ""
if [ "$UPDATED" -eq 0 ]; then
  echo "✓ Already up to date."
else
  echo "✓ Synced $UPDATED files. Review changes with: git diff"
  echo "  Commit when ready."
fi

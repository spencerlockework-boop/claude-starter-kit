#!/bin/bash
# restore-memory.sh
# Opposite of backup-memory.sh.
# Copies docs/memory-backup/ INTO ~/.claude/projects/<slug>/memory/
# Use when: fresh machine, wiped memory dir, or recovering from accidental delete.

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$REPO_ROOT/docs/memory-backup"
PROJECT_SLUG=$(echo "$REPO_ROOT" | sed 's|/|-|g')
MEMORY_DIR="$HOME/.claude/projects/$PROJECT_SLUG/memory"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "ERROR: No backup found at $BACKUP_DIR"
  echo "       Pull the repo fresh from git, then run this again."
  exit 1
fi

BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "$BACKUP_COUNT" = "0" ]; then
  echo "ERROR: Backup directory is empty"
  exit 1
fi

if [ -d "$MEMORY_DIR" ]; then
  EXISTING=$(ls -1 "$MEMORY_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
  echo "WARNING: Memory dir already exists with $EXISTING files at:"
  echo "  $MEMORY_DIR"
  echo ""
  echo "This will OVERWRITE existing files (but NOT delete extras)."
  read -p "Continue? [y/N] " -n 1 -r
  echo
  [[ ! $REPLY =~ ^[Yy]$ ]] && { echo "Aborted."; exit 0; }
fi

mkdir -p "$MEMORY_DIR"

# Copy all .md files, skip README (that's the backup's own readme)
for f in "$BACKUP_DIR"/*.md; do
  name=$(basename "$f")
  if [ "$name" != "README.md" ]; then
    cp "$f" "$MEMORY_DIR/$name"
  fi
done

RESTORED=$(ls -1 "$MEMORY_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "Restored $RESTORED memory files to $MEMORY_DIR"

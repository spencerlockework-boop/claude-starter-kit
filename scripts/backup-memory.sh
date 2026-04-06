#!/bin/bash
# backup-memory.sh
# Backs up Claude memory files to the repo (Git-independent backup).
# Memory lives at ~/.claude/projects/.../memory/ which is machine-local.
# This script copies them into docs/memory-backup/ so they ride along in git.
#
# Auto-detects the memory directory from the current repo path.
# Override with REPO_PATH or MEMORY_DIR env vars if needed.

set -e

# Default: derive from script location (works regardless of where you run from)
REPO_PATH="${REPO_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# Claude's project memory slug is the absolute path with / → -
if [ -z "$MEMORY_DIR" ]; then
  PROJECT_SLUG=$(echo "$REPO_PATH" | sed 's|/|-|g')
  MEMORY_DIR="$HOME/.claude/projects/$PROJECT_SLUG/memory"
fi

BACKUP_DIR="$REPO_PATH/docs/memory-backup"

if [ ! -d "$MEMORY_DIR" ]; then
  echo "ERROR: Memory dir not found: $MEMORY_DIR"
  echo "       Set MEMORY_DIR env var to override."
  exit 1
fi

mkdir -p "$BACKUP_DIR"

# Copy all memory .md files
cp "$MEMORY_DIR"/*.md "$BACKUP_DIR/" 2>/dev/null || true

# Add a README explaining the backup
cat > "$BACKUP_DIR/README.md" << EOF
# Memory Backup

This directory is an automated backup of Claude Code memory files from:
\`$MEMORY_DIR\`

**Purpose:** The real memory lives outside the repo (machine-local). This backup rides along in git so:
- A fresh clone on a new machine can restore memory
- If the memory dir gets wiped, git has history
- Team members (if any) can see decision history

**Do NOT edit files here directly** — edit the real ones at \`$MEMORY_DIR\`.

**To refresh backup:** run \`bash scripts/backup-memory.sh\` from the repo root.

**Last backup:** $(date '+%Y-%m-%d %H:%M:%S')
EOF

COUNT=$(ls -1 "$BACKUP_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "Backed up $COUNT memory files to $BACKUP_DIR"
echo "Commit them with: git add docs/memory-backup && git commit -m 'Backup memory files'"

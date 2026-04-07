#!/bin/bash
# refresh-docs.sh
# Run all automated documentation updates.
# Does NOT update docs that need Claude (project-map, architecture-review, audit-report, CLAUDE.md).

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "Refreshing automated docs in: $REPO_ROOT"
echo ""

# 1. Sync features from GitHub Issues (source of truth)
if [ -f scripts/sync-features-from-issues.sh ]; then
  echo "→ Syncing features from GitHub Issues..."
  bash scripts/sync-features-from-issues.sh
fi

# 2. Backup memory files to docs/memory-backup/
if [ -f scripts/backup-memory.sh ]; then
  echo "→ Backing up memory files..."
  bash scripts/backup-memory.sh
fi

# 3. Clean OS artifacts
echo "→ Cleaning .DS_Store files..."
find . -name ".DS_Store" -not -path "./node_modules/*" -not -path "./.git/*" -delete 2>/dev/null || true

# 4. Show git status so user can see what changed
echo ""
echo "Changes:"
git status --short

echo ""
echo "Docs that need Claude to update (use commands):"
echo "  - docs/tech.md           → /plan project"
echo "  - docs/architecture.md   → /plan project"
echo "  - docs/map.md            → /plan module <name>"
echo "  - CLAUDE.md              → edit manually when stack changes"
echo ""
echo "Auto-generated from GitHub Issues:"
echo "  docs/FEATURES.md + docs/features.json"
echo ""
echo "Session history:"
echo "  docs/handoffs/   → written by /handoff"
echo "  docs/audits/     → written by /audit"

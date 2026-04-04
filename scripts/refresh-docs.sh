#!/bin/bash
# refresh-docs.sh
# Run all automated documentation updates.
# Does NOT update docs that need Claude (sourcevault-map, architecture-review, audit-report, CLAUDE.md).

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "Refreshing automated docs in: $REPO_ROOT"
echo ""

# 1. Regenerate features.json from sourcevault-map.md
if [ -f scripts/export-features-db.sh ]; then
  echo "→ Regenerating docs/features.json..."
  bash scripts/export-features-db.sh
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
echo "Docs that STILL need Claude to update:"
echo "  - docs/sourcevault-map.md  (when adding/changing modules)  → use /spec"
echo "  - docs/architecture-review.md  (major architecture changes) → regenerate in fresh session"
echo "  - docs/audit-report.md  (periodic audits)  → use /audit"
echo "  - docs/FEATURES.md  (manual status updates)"
echo "  - CLAUDE.md  (stack or architecture changes)"
echo ""
echo "To sync universal files from starter kit:"
echo "  bash ~/Documents/Claude-Code-Repos/claude-starter-kit/scripts/sync-from-kit.sh"

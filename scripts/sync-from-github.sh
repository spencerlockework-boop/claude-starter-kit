#!/bin/bash
# sync-from-github.sh
# Pull latest universal Claude system files from GitHub into this repo.
# No local checkout needed — clones latest main, syncs, cleans up.

set -e

REPO_URL="${CLAUDE_KIT_REPO:-https://github.com/spencerlockework-boop/claude-starter-kit.git}"
BRANCH="${CLAUDE_KIT_BRANCH:-main}"
TARGET="${1:-$(pwd)}"

if [ ! -d "$TARGET/.claude" ]; then
  echo "ERROR: Target doesn't have .claude/ directory."
  echo "Run init first:"
  echo "  curl -s https://raw.githubusercontent.com/spencerlockework-boop/claude-starter-kit/main/scripts/init-from-github.sh | bash"
  exit 1
fi

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

echo "Fetching latest from $REPO_URL ($BRANCH)..."
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TMPDIR" 2>&1 | tail -3

echo "Syncing to $TARGET..."
bash "$TMPDIR/scripts/sync-from-kit.sh" "$TARGET"

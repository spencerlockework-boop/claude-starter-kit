#!/bin/bash
# init-from-github.sh
# Install the Claude Code starter kit from GitHub into the current directory.
# Run: curl -s https://raw.githubusercontent.com/spencerlockework-boop/claude-starter-kit/main/scripts/init-from-github.sh | bash

set -e

REPO_URL="${CLAUDE_KIT_REPO:-https://github.com/spencerlockework-boop/claude-starter-kit.git}"
BRANCH="${CLAUDE_KIT_BRANCH:-main}"
TARGET="${1:-$(pwd)}"

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

echo "Fetching latest kit from $REPO_URL..."
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TMPDIR" 2>&1 | tail -3

echo "Installing to $TARGET..."
bash "$TMPDIR/scripts/init-claude-system.sh" "$TARGET"

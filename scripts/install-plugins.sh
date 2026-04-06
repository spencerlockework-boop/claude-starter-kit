#!/bin/bash
# install-plugins.sh
# Prints plugin install commands from skills.json.
# Copy and paste the output into your Claude Code session.
# Usage: bash scripts/install-plugins.sh

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

SKILLS_MANIFEST="skills.json"

if [ ! -f "$SKILLS_MANIFEST" ]; then
  echo "ERROR: No skills.json found."
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "ERROR: jq required. Install with: brew install jq"
  exit 1
fi

echo "Plugin install commands — paste these into your Claude Code session:"
echo ""

# Collect unique marketplace add commands
echo "# Step 1: Add marketplaces"
jq -r '.plugins // {} | to_entries[] | .value.install' "$SKILLS_MANIFEST" | \
  grep -oE '/plugin marketplace add [^ ]+' | sort -u
echo ""

echo "# Step 2: Install plugins"
jq -r '.plugins // {} | to_entries[] | .value.install' "$SKILLS_MANIFEST" | \
  grep -oE '/plugin install [^ ]+' | sort -u
echo ""

echo "# Verify with: /plugin list"

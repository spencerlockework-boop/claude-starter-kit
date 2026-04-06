#!/bin/bash
# update-external-skills.sh
# Syncs external skills from upstream repos using skills.json manifest.
# Only syncs "single-file" type entries. Plugin entries are informational.
# Usage: bash scripts/update-external-skills.sh

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

SKILLS_MANIFEST="skills.json"
SKILLS_DIR=".claude/skills"
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

UPDATED=0
SKIPPED=0
FAILED=0

if [ ! -f "$SKILLS_MANIFEST" ]; then
  echo "ERROR: No skills.json found at repo root."
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "ERROR: jq is required. Install with: brew install jq (mac) or apt install jq (linux)"
  exit 1
fi

echo "Updating external skills..."
echo ""

# Get all top-level keys that aren't prefixed with _ and aren't "plugins" or "schema_version"
SKILLS=$(jq -r 'to_entries[] | select(.key | test("^(_|plugins$|schema_version$)") | not) | select(.value.type == "single-file") | .key' "$SKILLS_MANIFEST")

for skill in $SKILLS; do
  url=$(jq -r ".\"$skill\".source" "$SKILLS_MANIFEST")
  target="$SKILLS_DIR/$skill/SKILL.md"

  # Validate skill name (alphanumeric, hyphens, underscores only)
  if ! echo "$skill" | grep -qE '^[a-zA-Z0-9_-]+$'; then
    printf "  %-25s SKIP (invalid name)\n" "$skill"
    FAILED=$((FAILED + 1))
    continue
  fi

  printf "  %-25s " "$skill"
  mkdir -p "$SKILLS_DIR/$skill"

  if curl --fail --silent --show-error --max-time 10 "$url" -o "$TEMP_DIR/$skill.md" 2>/dev/null; then
    # Check if file is non-empty
    if [ ! -s "$TEMP_DIR/$skill.md" ]; then
      echo "FAIL (empty response)"
      FAILED=$((FAILED + 1))
      continue
    fi

    if [ -f "$target" ] && diff -q "$TEMP_DIR/$skill.md" "$target" &>/dev/null; then
      echo "no changes"
      SKIPPED=$((SKIPPED + 1))
    else
      cp "$TEMP_DIR/$skill.md" "$target"
      # Update lastSync timestamp in manifest
      NOW=$(date +%Y-%m-%d)
      TMP_MANIFEST=$(mktemp)
      jq ".\"$skill\".lastSync = \"$NOW\"" "$SKILLS_MANIFEST" > "$TMP_MANIFEST"
      mv "$TMP_MANIFEST" "$SKILLS_MANIFEST"
      echo "updated"
      UPDATED=$((UPDATED + 1))
    fi
  else
    echo "FAIL (fetch error)"
    FAILED=$((FAILED + 1))
  fi
done

echo ""
echo "Results: $UPDATED updated, $SKIPPED unchanged, $FAILED failed"

# Show plugin install reminders
PLUGINS=$(jq -r '.plugins // {} | keys[]' "$SKILLS_MANIFEST" 2>/dev/null)
if [ -n "$PLUGINS" ]; then
  echo ""
  echo "Plugin-based skills (install manually in Claude Code):"
  for plugin in $PLUGINS; do
    install_cmd=$(jq -r ".plugins.\"$plugin\".install" "$SKILLS_MANIFEST")
    desc=$(jq -r ".plugins.\"$plugin\".description" "$SKILLS_MANIFEST")
    echo "  $desc"
    echo "    $install_cmd"
    echo ""
  done
fi

[ $UPDATED -gt 0 ] && echo "Run 'git diff $SKILLS_DIR' to review changes."

#!/bin/bash
# push-to-issues.sh
# Push tasks as GitHub Issues in bulk.
# Reads a TSV file: title<TAB>body<TAB>labels<TAB>assignee
# Skips rows where title already matches an existing issue.
#
# Usage:
#   bash scripts/push-to-issues.sh tasks.tsv
#   cat tasks.tsv | bash scripts/push-to-issues.sh

set -e

if ! command -v gh &> /dev/null; then
  echo "ERROR: gh CLI not installed. https://cli.github.com/"
  exit 1
fi

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
if [ -z "$REPO" ]; then
  echo "ERROR: Not inside a GitHub repo"
  exit 1
fi

INPUT="${1:-/dev/stdin}"

if [ "$INPUT" != "/dev/stdin" ] && [ ! -f "$INPUT" ]; then
  echo "ERROR: File not found: $INPUT"
  exit 1
fi

echo "Fetching existing issues from $REPO..."
EXISTING=$(gh issue list --repo "$REPO" --state all --limit 200 --json title -q '.[].title' 2>/dev/null)

CREATED=0
SKIPPED=0

while IFS=$'\t' read -r title body labels assignee; do
  [ -z "$title" ] && continue
  [[ "$title" =~ ^# ]] && continue

  if echo "$EXISTING" | grep -qxF "$title"; then
    echo "SKIP   $title"
    SKIPPED=$((SKIPPED+1))
    continue
  fi

  CMD=(gh issue create --repo "$REPO" --title "$title" --body "${body:-No description.}")
  [ -n "$labels" ] && CMD+=(--label "$labels")
  [ -n "$assignee" ] && CMD+=(--assignee "$assignee")

  if URL=$("${CMD[@]}" 2>&1); then
    echo "CREATE $title → $URL"
    CREATED=$((CREATED+1))
  else
    echo "FAIL   $title: $URL"
  fi
done < "$INPUT"

echo ""
echo "Done: $CREATED created, $SKIPPED already existed"
echo "Sync to local: bash scripts/sync-features-from-issues.sh"

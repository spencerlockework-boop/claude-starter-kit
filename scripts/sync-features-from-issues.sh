#!/bin/bash
# sync-features-from-issues.sh
# Pull open GitHub issues into a snapshot for docs/FEATURES.md + docs/features.json.
# GitHub Issues are the source of truth. This just mirrors them locally.

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if ! command -v gh &> /dev/null; then
  echo "ERROR: gh CLI not installed. https://cli.github.com/"
  exit 1
fi

# Auto-detect repo from git remote, or use GITHUB_REPO env var
if [ -z "$GITHUB_REPO" ]; then
  REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
  if [ -z "$REPO" ]; then
    echo "ERROR: Could not detect GitHub repo. Set GITHUB_REPO env var or run from inside a GitHub repo."
    exit 1
  fi
else
  REPO="$GITHUB_REPO"
fi

echo "Fetching issues from $REPO..."

# Fetch open issues as JSON
gh issue list --repo "$REPO" --state open --limit 100 \
  --json number,title,labels,assignees,updatedAt,url \
  > docs/features.json

COUNT=$(jq 'length' docs/features.json)
echo "Synced $COUNT open issues to docs/features.json"

# Generate a human-readable FEATURES.md snapshot
REPO="$REPO" python3 << 'PYEOF'
import json
import os
from datetime import datetime
from pathlib import Path

repo = os.environ.get("REPO", "")
issues = json.loads(Path("docs/features.json").read_text())

# Group by primary label
by_label = {}
for issue in issues:
    labels = [l["name"] for l in issue.get("labels", [])]
    primary = labels[0] if labels else "unlabeled"
    by_label.setdefault(primary, []).append(issue)

out = ["# Feature Tracker", ""]
out.append(f"Snapshot of open GitHub Issues from `{repo}`.")
out.append(f"Generated: {datetime.now().isoformat()}")
out.append("")
out.append("**GitHub Issues are the source of truth.** This file is a local mirror.")
out.append("")
out.append("Refresh: `bash scripts/sync-features-from-issues.sh`")
out.append("")

for label, items in sorted(by_label.items()):
    out.append(f"## {label}")
    out.append("")
    out.append("| # | Title | Assignees | Updated |")
    out.append("|---|-------|-----------|---------|")
    for issue in items:
        assignees = ", ".join(a["login"] for a in issue.get("assignees", [])) or "—"
        updated = issue["updatedAt"][:10]
        num = issue["number"]
        title = issue["title"].replace("|", "\\|")
        url = issue["url"]
        out.append(f"| [#{num}]({url}) | {title} | {assignees} | {updated} |")
    out.append("")

Path("docs/FEATURES.md").write_text("\n".join(out))
print(f"Generated docs/FEATURES.md ({len(issues)} issues across {len(by_label)} labels)")
PYEOF

echo ""
echo "Done. Commit with: git add docs/FEATURES.md docs/features.json && git commit -m 'Sync features from GitHub Issues'"

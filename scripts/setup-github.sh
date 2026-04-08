#!/bin/bash
# setup-github.sh
# Create standardized GitHub labels matching agent routing and workflow.
# Run once per GitHub repo. Safe to re-run — skips existing labels.
#
# Usage: bash scripts/setup-github.sh

set -e

if ! command -v gh &>/dev/null; then
  echo "ERROR: gh CLI not installed. https://cli.github.com/"
  exit 1
fi

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
if [ -z "$REPO" ]; then
  echo "ERROR: Not inside a GitHub repo, or not authenticated."
  echo "Run: gh auth login"
  exit 1
fi

echo "Creating labels on $REPO..."
echo ""

CREATED=0
SKIPPED=0

create_label() {
  local name="$1"
  local color="$2"
  local description="$3"

  if gh label create "$name" --repo "$REPO" --color "$color" --description "$description" 2>/dev/null; then
    echo "  created: $name"
    CREATED=$((CREATED+1))
  else
    echo "  exists:  $name"
    SKIPPED=$((SKIPPED+1))
  fi
}

# Area labels (match issue template dropdowns)
create_label "frontend"    "1d76db" "Frontend / UI work"
create_label "backend"     "0e8a16" "API / server / database work"
create_label "infra"       "d93f0b" "Infrastructure / DevOps"
create_label "database"    "006b75" "Schema / migrations / queries"

# Type labels
create_label "feature"     "a2eeef" "New feature or enhancement"
create_label "bug"         "d73a4a" "Something is broken"
create_label "cleanup"     "fef2c0" "Dead code, stubs, tech debt"
create_label "docs"        "0075ca" "Documentation"

# Priority labels
create_label "critical"    "b60205" "Must fix immediately"
create_label "high"        "ff9f1c" "Fix this sprint"

# Agent routing labels
create_label "agent:frontend-builder"  "c5def5" "Route to frontend-builder subagent"
create_label "agent:backend-builder"   "c5def5" "Route to backend-builder subagent"
create_label "agent:architect"         "c5def5" "Route to architect subagent"

# Workflow labels
create_label "automated"   "ededed" "Created by automation (nightly cleanup, etc.)"

echo ""
echo "Done: $CREATED created, $SKIPPED already existed."

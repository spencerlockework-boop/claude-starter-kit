#!/bin/bash
# doctor.sh
# Health-check for a Claude Code project environment.
# Generic — works in any repo that uses the starter kit.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

PASS=0
FAIL=0
WARN=0

green() { echo -e "\033[32m✓\033[0m $1"; PASS=$((PASS+1)); }
red()   { echo -e "\033[31m✗\033[0m $1"; FAIL=$((FAIL+1)); }
yellow(){ echo -e "\033[33m!\033[0m $1"; WARN=$((WARN+1)); }

echo "Claude Code doctor — checking environment..."
echo ""

# --- Core tools ---
echo "Tools:"
command -v git >/dev/null 2>&1 && green "git ($(git --version | cut -d' ' -f3))" || red "git — install from git-scm.com"
command -v node >/dev/null 2>&1 && green "node ($(node --version))" || yellow "node — install from nodejs.org"
command -v gh >/dev/null 2>&1 && green "gh CLI" || yellow "gh CLI — install from cli.github.com"
command -v jq >/dev/null 2>&1 && green "jq" || yellow "jq — needed for update-external-skills.sh"

if command -v claude >/dev/null 2>&1; then
  green "claude CLI"
else
  yellow "claude CLI — install from https://docs.anthropic.com/en/docs/claude-code"
fi

echo ""
echo "Git:"
if git rev-parse --is-inside-work-tree &>/dev/null; then
  green "git repo (branch: $(git branch --show-current))"
  if [ -z "$(git status --porcelain)" ]; then
    green "working tree clean"
  else
    DIRTY=$(git status --porcelain | wc -l | tr -d ' ')
    yellow "$DIRTY uncommitted changes"
  fi
  UNPUSHED=$(git log origin/$(git branch --show-current)..HEAD --oneline 2>/dev/null | wc -l | tr -d ' ')
  if [ "$UNPUSHED" = "0" ]; then
    green "all commits pushed"
  else
    yellow "$UNPUSHED unpushed commits"
  fi
else
  red "not a git repo"
fi

echo ""
echo "Claude Code system:"
[ -f CLAUDE.md ] && green "CLAUDE.md present" || red "CLAUDE.md missing"
[ -f .claude/settings.json ] && green ".claude/settings.json" || yellow ".claude/settings.json missing"
[ -d .claude/agents ] && green ".claude/agents/ ($(ls .claude/agents/*.md 2>/dev/null | wc -l | tr -d ' ') agents)" || red ".claude/agents/ missing"
[ -d .claude/commands ] && green ".claude/commands/ ($(ls .claude/commands/*.md 2>/dev/null | wc -l | tr -d ' ') commands)" || red ".claude/commands/ missing"
[ -d .claude/skills ] && green ".claude/skills/ ($(ls .claude/skills/*.md 2>/dev/null | wc -l | tr -d ' ') skills)" || yellow ".claude/skills/ not found"

PROJECT_SLUG=$(echo "$REPO_ROOT" | sed 's|/|-|g')
MEMORY_DIR="$HOME/.claude/projects/$PROJECT_SLUG/memory"
if [ -d "$MEMORY_DIR" ]; then
  COUNT=$(ls -1 "$MEMORY_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
  green "memory dir ($COUNT files)"
else
  yellow "memory dir not found (first session will create it)"
fi

echo ""
echo "Environment:"
if [ -n "$CLAUDE_CODE_SUBAGENT_MODEL" ]; then
  green "CLAUDE_CODE_SUBAGENT_MODEL=$CLAUDE_CODE_SUBAGENT_MODEL"
else
  yellow "CLAUDE_CODE_SUBAGENT_MODEL not set — subagents will use same model as main (costs more)"
fi

if [ -n "$ANTHROPIC_API_KEY" ]; then
  green "ANTHROPIC_API_KEY set"
elif [ -f "$HOME/.claude/config.json" ]; then
  green "Claude auth config exists"
else
  yellow "no auth detected (set ANTHROPIC_API_KEY or run 'claude login')"
fi

echo ""
echo "Summary: $PASS passing, $WARN warnings, $FAIL failing"
echo ""
if [ $FAIL -gt 0 ]; then
  echo "Status: NOT HEALTHY — fix red items above"
  exit 1
elif [ $WARN -gt 0 ]; then
  echo "Status: USABLE — warnings can wait"
else
  echo "Status: HEALTHY"
fi

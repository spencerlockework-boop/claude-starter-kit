#!/bin/bash
# doctor.sh
# Health-check for the SourceVault dev environment.
# Reports what's working, what's broken, and what to do about it.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

PASS=0
FAIL=0
WARN=0

green() { echo -e "\033[32m✓\033[0m $1"; PASS=$((PASS+1)); }
red()   { echo -e "\033[31m✗\033[0m $1"; FAIL=$((FAIL+1)); }
yellow(){ echo -e "\033[33m!\033[0m $1"; WARN=$((WARN+1)); }

echo "SourceVault doctor — checking dev environment..."
echo ""

# --- Tools ---
echo "Tools:"
command -v node >/dev/null 2>&1 && green "node ($(node --version))" || red "node — install from nodejs.org"
command -v pnpm >/dev/null 2>&1 && green "pnpm ($(pnpm --version))" || red "pnpm — run: npm install -g pnpm"
command -v docker >/dev/null 2>&1 && green "docker" || red "docker — install Docker Desktop"
command -v gh >/dev/null 2>&1 && green "gh CLI" || yellow "gh CLI — install from cli.github.com"
command -v cargo >/dev/null 2>&1 && green "cargo (Rust)" || yellow "cargo — needed for workers"
command -v ffmpeg >/dev/null 2>&1 && green "ffmpeg" || yellow "ffmpeg — needed for workers"

# --- Node version ---
if command -v node >/dev/null 2>&1; then
  NODE_MAJOR=$(node --version | sed 's/v//' | cut -d. -f1)
  if [ "$NODE_MAJOR" -ge 22 ]; then
    green "node >= 22"
  else
    red "node $NODE_MAJOR, need >= 22"
  fi
fi

echo ""
echo "Dependencies:"
if [ -d node_modules ] && [ -d apps/web/node_modules ]; then
  green "pnpm dependencies installed"
else
  red "missing — run: pnpm install"
fi

echo ""
echo "Git:"
if [ -z "$(git status --porcelain)" ]; then
  green "working tree clean"
else
  DIRTY=$(git status --porcelain | wc -l | tr -d ' ')
  yellow "$DIRTY uncommitted changes"
fi

UNPUSHED=$(git log origin/main..main --oneline 2>/dev/null | wc -l | tr -d ' ')
if [ "$UNPUSHED" = "0" ]; then
  green "all commits pushed"
else
  yellow "$UNPUSHED unpushed commits"
fi

echo ""
echo "Services (Docker):"
if ! docker info >/dev/null 2>&1; then
  red "docker daemon not running"
else
  green "docker daemon running"
  for svc in postgres redis minio; do
    if docker ps --format '{{.Names}}' | grep -q "$svc"; then
      green "$svc container running"
    else
      yellow "$svc not running — run: docker compose up -d"
    fi
  done
fi

echo ""
echo "Config:"
if [ -f .env ]; then
  green ".env exists"
else
  yellow ".env missing — run: cp .env.example .env"
fi

echo ""
echo "Database migrations:"
if docker ps --format '{{.Names}}' | grep -q "postgres"; then
  PG_CONTAINER=$(docker ps --filter "name=postgres" --format '{{.Names}}' | head -1)
  if docker exec "$PG_CONTAINER" psql -U mam -d mam -c "\d notifications" >/dev/null 2>&1; then
    green "notifications table exists"
  else
    red "notifications table missing — run: pnpm db:migrate"
  fi
  if docker exec "$PG_CONTAINER" psql -U mam -d mam -c "\d assets" 2>/dev/null | grep -q "is_new"; then
    green "assets.is_new column exists"
  else
    yellow "assets.is_new missing — run: pnpm db:generate && pnpm db:migrate"
  fi
else
  yellow "postgres not running — can't check migrations"
fi

echo ""
echo "Claude Code system:"
[ -f CLAUDE.md ] && green "CLAUDE.md present" || red "CLAUDE.md missing"
[ -d .claude/agents ] && green ".claude/agents/ ($(ls .claude/agents/ | wc -l | tr -d ' ') agents)" || red ".claude/agents/ missing"
[ -d .claude/commands ] && green ".claude/commands/ ($(ls .claude/commands/ | wc -l | tr -d ' ') commands)" || red ".claude/commands/ missing"

PROJECT_SLUG=$(echo "$REPO_ROOT" | sed 's|/|-|g')
MEMORY_DIR="$HOME/.claude/projects/$PROJECT_SLUG/memory"
if [ -d "$MEMORY_DIR" ]; then
  COUNT=$(ls -1 "$MEMORY_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
  green "memory dir ($COUNT files)"
else
  yellow "memory dir not found"
fi

if [ -n "$CLAUDE_CODE_SUBAGENT_MODEL" ]; then
  green "CLAUDE_CODE_SUBAGENT_MODEL set"
else
  yellow "CLAUDE_CODE_SUBAGENT_MODEL not set"
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

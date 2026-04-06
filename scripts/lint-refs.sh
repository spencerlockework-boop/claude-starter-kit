#!/bin/bash
# lint-refs.sh
# Catches stale cross-file references.
# Checks that every script/file mentioned in init, sync, and uninstall actually exists.
# Run: bash scripts/lint-refs.sh

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

ERRORS=0

echo "Checking cross-file references..."

# 1. Scripts referenced in init/sync/uninstall must exist
for ref_file in scripts/init-claude-system.sh scripts/sync-from-kit.sh scripts/uninstall.sh; do
  [ ! -f "$ref_file" ] && continue
  # Find .sh filenames mentioned in cp/rm/for lines
  grep -oE '[a-z_-]+\.sh' "$ref_file" | sort -u | while read -r script; do
    # Skip self-references and kit-only scripts
    case "$script" in
      init-claude-system.sh|init-from-github.sh|sync-from-kit.sh|sync-from-github.sh|lint-refs.sh) continue ;;
    esac
    if [ ! -f "scripts/$script" ]; then
      echo "  ERROR: $ref_file references scripts/$script — file does not exist"
      ERRORS=$((ERRORS+1))
    fi
  done
done

# 2. Commands referenced in uninstall must exist (or be in templates)
grep -oE '[a-z_-]+\.md' scripts/uninstall.sh 2>/dev/null | sort -u | while read -r cmd; do
  if [ ! -f ".claude/commands/$cmd" ] && [ ! -f ".claude/agents/$cmd" ] && [ ! -f "templates/commands/$cmd" ]; then
    echo "  WARN: uninstall.sh references $cmd — not found in commands/agents/templates"
  fi
done

# 3. Check README script table references
grep -oE 'scripts/[a-z_-]+\.sh' README.md 2>/dev/null | sort -u | while read -r script_path; do
  if [ ! -f "$script_path" ]; then
    echo "  ERROR: README.md references $script_path — file does not exist"
    ERRORS=$((ERRORS+1))
  fi
done

# 4. Check for orphan scripts (exist but not mentioned in init or sync)
for script in scripts/*.sh; do
  name=$(basename "$script")
  case "$name" in
    init-claude-system.sh|init-from-github.sh|sync-from-kit.sh|sync-from-github.sh|lint-refs.sh) continue ;;
  esac
  if ! grep -q "$name" scripts/init-claude-system.sh 2>/dev/null && \
     ! grep -q "$name" scripts/sync-from-kit.sh 2>/dev/null; then
    echo "  WARN: scripts/$name exists but isn't in init or sync — won't be installed"
  fi
done

echo ""
if [ "$ERRORS" = "0" ]; then
  echo "All references OK."
else
  echo "Found reference errors — fix before committing."
  exit 1
fi

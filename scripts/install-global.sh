#!/bin/bash
# install-global.sh
# Install user-scoped Claude Code config to ~/.claude/
# Run once per machine. Safe to re-run — won't overwrite existing files.
#
# What it creates:
#   ~/.claude/CLAUDE.md          (global preferences for all repos)
#   ~/.claude/settings.json      (global deny rules — merged with project settings)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"

CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

INSTALLED=0

# Install global CLAUDE.md
if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$KIT_ROOT/templates/global-CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
  echo "  created: ~/.claude/CLAUDE.md"
  INSTALLED=$((INSTALLED+1))
else
  echo "  exists:  ~/.claude/CLAUDE.md (not overwritten)"
fi

# Install global settings.json (deny rules that apply to all repos)
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
  cat > "$CLAUDE_DIR/settings.json" << 'EOF'
{
  "permissions": {
    "deny": [
      "Bash(rm -rf *)",
      "Bash(rm -rf /*)",
      "Bash(rm -rf ./*)",
      "Bash(git push --force*)",
      "Bash(git push -f*)",
      "Bash(git reset --hard*)",
      "Bash(git clean -f*)",
      "Bash(git branch -D main*)",
      "Bash(git branch -D master*)",
      "Read(.env)",
      "Read(.env.local)",
      "Read(.env.production)",
      "Read(.env.*)"
    ],
    "allow": [
      "Read(.env.example)"
    ]
  }
}
EOF
  echo "  created: ~/.claude/settings.json"
  INSTALLED=$((INSTALLED+1))
else
  echo "  exists:  ~/.claude/settings.json (not overwritten)"
fi

echo ""
if [ $INSTALLED -gt 0 ]; then
  echo "Installed $INSTALLED global config file(s)."
  echo "Edit ~/.claude/CLAUDE.md with your personal preferences."
else
  echo "Global config already exists. Nothing to do."
fi

echo ""
echo "Recommended: add to your shell profile (~/.zshrc or ~/.bashrc):"
echo "  export CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6"

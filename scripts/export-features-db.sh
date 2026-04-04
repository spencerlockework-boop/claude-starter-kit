#!/bin/bash
# export-features-db.sh
# Generates docs/features.json — a machine-readable snapshot of module status.
# Used for quick reference without reading long markdown docs.

set -e

REPO_PATH="${REPO_PATH:-/path/to/your-project}"
OUTPUT="$REPO_PATH/docs/features.json"

cd "$REPO_PATH"

# Extract module status from sourcevault-map.md status table
# Format: rows matching "| N | Module | Status | ... |"

python3 << 'PYEOF'
import re
import json
from pathlib import Path
from datetime import datetime

map_file = Path("docs/sourcevault-map.md")
if not map_file.exists():
    print("No sourcevault-map.md found")
    exit(0)

content = map_file.read_text()

# Find the status table (between "Module Spec Status" and the next "---")
match = re.search(r"## Module Spec Status\n\n(.+?)\n\n---", content, re.DOTALL)
if not match:
    print("Status table not found in sourcevault-map.md")
    exit(0)

table = match.group(1)
rows = [line for line in table.split("\n") if line.startswith("|") and not line.startswith("|---") and not line.startswith("| #")]

modules = []
for row in rows:
    cells = [c.strip() for c in row.split("|")[1:-1]]
    if len(cells) >= 5:
        modules.append({
            "id": cells[0],
            "name": cells[1].replace("**", "").replace("~~", "").strip(),
            "status": cells[2],
            "has_spec": cells[3],
            "notes": cells[4]
        })

output = {
    "generated": datetime.now().isoformat(),
    "source": "docs/sourcevault-map.md",
    "modules": modules,
    "count": len(modules)
}

Path("docs/features.json").write_text(json.dumps(output, indent=2))
print(f"✓ Exported {len(modules)} modules to docs/features.json")
PYEOF

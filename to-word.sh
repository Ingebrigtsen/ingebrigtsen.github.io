#!/usr/bin/env bash
# Converts a Markdown file to a Word document (.docx).
# Mermaid diagrams are pre-rendered to PNG via mmdc before pandoc runs.
# Dependencies (pandoc, mmdc) are installed automatically if missing.
#
# Usage: ./to-word.sh <input.md> <output.docx>

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $(basename "$0") <input.md> <output.docx>" >&2
  exit 1
fi

INPUT="$(realpath "$1")"
# realpath requires the file to exist; resolve output relative to cwd manually
if [[ "$2" = /* ]]; then
  OUTPUT="$2"
else
  OUTPUT="$PWD/$2"
fi
TMPDIR_LOCAL="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_LOCAL"' EXIT

# ── auto-install mmdc (Mermaid CLI) ──────────────────────────────────────────
if ! command -v mmdc &>/dev/null; then
  echo "Installing @mermaid-js/mermaid-cli (mmdc)…"
  npm install -g @mermaid-js/mermaid-cli
fi

# ── auto-install pandoc ───────────────────────────────────────────────────────
if ! command -v pandoc &>/dev/null; then
  echo "Installing pandoc…"
  brew install pandoc
fi

echo "Converting $INPUT → $OUTPUT"

# ── pre-render Mermaid blocks to PNG images ───────────────────────────────────
# Extract each ```mermaid … ``` block, render it with mmdc, replace with ![](…)
PROCESSED="$TMPDIR_LOCAL/processed.md"
python3 - "$INPUT" "$TMPDIR_LOCAL" <<'PYEOF'
import sys, re, subprocess, os, pathlib

src   = pathlib.Path(sys.argv[1]).read_text()
tmpd  = sys.argv[2]
count = 0
out   = []
pos   = 0

for m in re.finditer(r'```mermaid\n(.*?)```', src, re.DOTALL):
    out.append(src[pos:m.start()])
    diagram = m.group(1)
    img     = os.path.join(tmpd, f"mermaid-{count}.png")
    mmd     = os.path.join(tmpd, f"mermaid-{count}.mmd")
    pathlib.Path(mmd).write_text(diagram)
    subprocess.run(
        ["mmdc", "-i", mmd, "-o", img, "-b", "white", "-w", "1200"],
        check=True, capture_output=True
    )
    out.append(f"![]({img})")
    pos = m.end()
    count += 1

out.append(src[pos:])
pathlib.Path(sys.argv[2] + "/processed.md").write_text("".join(out))
print(f"  {count} Mermaid diagram(s) rendered.")
PYEOF

pandoc "$PROCESSED" \
  --from=markdown+fenced_code_blocks+pipe_tables \
  --to=docx \
  --toc \
  --toc-depth=2 \
  --output="$OUTPUT"

echo "Done: $OUTPUT"

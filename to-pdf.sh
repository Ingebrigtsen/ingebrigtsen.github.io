#!/usr/bin/env bash
# Converts a Markdown file to PDF.
# Mermaid diagrams are pre-rendered to PNG via mmdc before pandoc runs.
# Dependencies (pandoc, basictex, mmdc) are installed automatically if missing.
#
# Usage: ./to-pdf.sh <input.md> <output.pdf>

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $(basename "$0") <input.md> <output.pdf>" >&2
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

# ── helper: add basictex bin dir to PATH ──────────────────────────────────────
add_texlive_to_path() {
  local bin
  bin="$(find /usr/local/texlive -maxdepth 4 -name "xelatex" 2>/dev/null | head -1 | xargs -I{} dirname {} 2>/dev/null || true)"
  if [[ -n "$bin" && ":$PATH:" != *":$bin:"* ]]; then
    export PATH="$bin:$PATH"
  fi
}

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

# ── auto-install basictex + fonts ────────────────────────────────────────────
add_texlive_to_path
if ! command -v xelatex &>/dev/null && ! command -v pdflatex &>/dev/null; then
  echo "Installing basictex…"
  brew install --cask basictex
  add_texlive_to_path
fi

# tlmgr lives in the texlive bin dir; ensure it's reachable
TLMGR="$(command -v tlmgr 2>/dev/null || find /usr/local/texlive -maxdepth 4 -name "tlmgr" 2>/dev/null | head -1 || true)"
if [[ -n "$TLMGR" ]]; then
  echo "Updating tlmgr and installing required packages…"
  sudo "$TLMGR" update --self --no-auto-install 2>/dev/null || true
  sudo "$TLMGR" install \
    collection-fontsrecommended \
    framed \
    fvextra \
    upquote \
    microtype \
    xcolor \
    mdframed \
    needspace \
    etoolbox \
    footnotehyper \
    footnote \
    booktabs \
    2>/dev/null || true
fi

# Prefer xelatex for better Unicode/font support; fall back to pdflatex.
if command -v xelatex &>/dev/null; then
  PDF_ENGINE=xelatex
else
  PDF_ENGINE=pdflatex
fi

echo "Converting $INPUT → $OUTPUT  (engine: $PDF_ENGINE)"

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
  --pdf-engine="$PDF_ENGINE" \
  --from=markdown+fenced_code_blocks+pipe_tables \
  --variable geometry:margin=2.5cm \
  --variable fontsize=11pt \
  --variable linkcolor=blue \
  --variable urlcolor=blue \
  --variable toccolor=black \
  --toc \
  --toc-depth=2 \
  --syntax-highlighting=tango \
  --output="$OUTPUT"

echo "Done: $OUTPUT"

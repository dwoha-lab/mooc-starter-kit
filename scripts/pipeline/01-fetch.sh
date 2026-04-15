#!/bin/bash
# 01-fetch.sh — stage 1 of 4: fetch
#
# USAGE:
#   ./01-fetch.sh [source-dir]
#
#   source-dir defaults to ../../sample-docs relative to this script.
#
# REQUIREMENTS:
#   - bash, find, cp, date
#
# WHAT IT DOES:
#   Copies matching source files (*.md, *.txt, *.html) from the source
#   directory into ./work/01-raw/ with a timestamp manifest. No content
#   transformation happens here — that's the next stage's job.
#
# INPUT:
#   A directory of journalism documents.
#
# OUTPUT:
#   ./work/01-raw/<filename>           — copied files
#   ./work/01-raw/_manifest.tsv        — fetched_at \t source_path \t filename
#
# OWNS:    grabbing the bytes
# HANDS OFF TO: 02-clean.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_SOURCE="$(cd "$SCRIPT_DIR/../../sample-docs" 2>/dev/null && pwd || echo "")"
SOURCE_DIR="${1:-$DEFAULT_SOURCE}"

if [ -z "$SOURCE_DIR" ] || [ ! -d "$SOURCE_DIR" ]; then
    echo "01-fetch: source directory not found: ${SOURCE_DIR:-<empty>}" >&2
    echo "usage: $0 [source-dir]" >&2
    exit 1
fi

OUT_DIR="./work/01-raw"
mkdir -p "$OUT_DIR"
MANIFEST="$OUT_DIR/_manifest.tsv"
: > "$MANIFEST"

NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
COUNT=0

while IFS= read -r -d '' FILE; do
    BASE="$(basename "$FILE")"
    cp "$FILE" "$OUT_DIR/$BASE"
    printf '%s\t%s\t%s\n' "$NOW" "$FILE" "$BASE" >> "$MANIFEST"
    COUNT=$((COUNT + 1))
done < <(find "$SOURCE_DIR" -maxdepth 1 -type f \( -name '*.md' -o -name '*.txt' -o -name '*.html' \) -print0)

if [ "$COUNT" -eq 0 ]; then
    echo "01-fetch: no .md/.txt/.html files found in $SOURCE_DIR" >&2
    exit 1
fi

echo "01-fetch: copied $COUNT files from $SOURCE_DIR to $OUT_DIR"

#!/bin/bash
# 02-clean.sh — stage 2 of 4: clean
#
# USAGE:
#   ./02-clean.sh
#
# REQUIREMENTS:
#   - bash, perl (for multi-line HTML stripping)
#   - 01-fetch.sh has already run and populated ./work/01-raw/
#
# WHAT IT DOES:
#   Strips HTML tags, collapses whitespace, normalizes line endings, and
#   writes a plain-text version of each file to ./work/02-clean/. No model
#   calls here — keep cleaning deterministic and free.
#
# INPUT:
#   ./work/01-raw/*.{md,txt,html}
#
# OUTPUT:
#   ./work/02-clean/<basename>.txt
#
# OWNS:    making the text safe to feed a model
# HANDS OFF TO: 03-process.sh

set -euo pipefail

IN_DIR="./work/01-raw"
OUT_DIR="./work/02-clean"

if [ ! -d "$IN_DIR" ]; then
    echo "02-clean: input dir not found: $IN_DIR (run 01-fetch.sh first)" >&2
    exit 1
fi

mkdir -p "$OUT_DIR"
COUNT=0

shopt -s nullglob
for FILE in "$IN_DIR"/*.md "$IN_DIR"/*.txt "$IN_DIR"/*.html; do
    [ -f "$FILE" ] || continue
    BASE="$(basename "$FILE")"
    OUT="$OUT_DIR/${BASE%.*}.txt"

    # Strip script/style blocks (multi-line safe via perl -0 slurp), then
    # tags, then decode common entities, then collapse whitespace.
    perl -0777 -pe '
        s{<script\b[^>]*>.*?</script>}{}gis;
        s{<style\b[^>]*>.*?</style>}{}gis;
        s{<!--.*?-->}{}gs;
        s{<[^>]+>}{}gs;
        s{&nbsp;}{ }g;
        s{&amp;}{&}g;
        s{&lt;}{<}g;
        s{&gt;}{>}g;
        s{&quot;}{"}g;
        s{&#39;}{'\''}g;
        s{\s+}{ }g;
        s{^\s+|\s+$}{}g;
    ' "$FILE" > "$OUT"

    COUNT=$((COUNT + 1))
done

if [ "$COUNT" -eq 0 ]; then
    echo "02-clean: nothing to clean in $IN_DIR" >&2
    exit 1
fi

echo "02-clean: cleaned $COUNT files into $OUT_DIR"

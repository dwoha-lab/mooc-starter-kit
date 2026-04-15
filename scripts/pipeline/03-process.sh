#!/bin/bash
# 03-process.sh — stage 3 of 4: process
#
# USAGE:
#   ./03-process.sh
#
# REQUIREMENTS:
#   - bash, claude (Claude Code CLI) on $PATH
#   - ANTHROPIC_API_KEY in env (or an active Claude Code login)
#   - 02-clean.sh has already run and populated ./work/02-clean/
#
# WHAT IT DOES:
#   Calls `claude -p` on each cleaned file with a beat-analysis prompt.
#   Asks for key facts, named entities, and unverified claims as JSON-shaped
#   output. Writes one .json file per input.
#
#   Tip: for streaming progress on large batches, swap the call for
#     claude -p --output-format stream-json "$PROMPT ..."
#   and parse incrementally with jq.
#
# INPUT:
#   ./work/02-clean/*.txt
#
# OUTPUT:
#   ./work/03-processed/<basename>.json
#
# OWNS:    the model call and the prompt shape
# HANDS OFF TO: 04-save.sh

set -euo pipefail

IN_DIR="./work/02-clean"
OUT_DIR="./work/03-processed"

if [ ! -d "$IN_DIR" ]; then
    echo "03-process: input dir not found: $IN_DIR (run 02-clean.sh first)" >&2
    exit 1
fi

if ! command -v claude >/dev/null 2>&1; then
    echo "03-process: 'claude' not found on PATH" >&2
    exit 1
fi

mkdir -p "$OUT_DIR"

PROMPT='You are a beat reporter assistant. Read the document below and return a single JSON object with these keys:
  "summary": one to two sentences,
  "key_facts": array of strings,
  "named_entities": array of {"name": string, "type": "person|org|place"},
  "unverified_claims": array of strings (claims that need a primary source).
Return ONLY the JSON object, no prose.'

COUNT=0
shopt -s nullglob
for FILE in "$IN_DIR"/*.txt; do
    BASE="$(basename "$FILE" .txt)"
    OUT="$OUT_DIR/$BASE.json"
    CONTENT="$(cat "$FILE")"

    if ! claude -p "$PROMPT

---
$CONTENT" > "$OUT"; then
        echo "03-process: claude failed on $BASE" >&2
        exit 1
    fi
    COUNT=$((COUNT + 1))
done

if [ "$COUNT" -eq 0 ]; then
    echo "03-process: nothing to process in $IN_DIR" >&2
    exit 1
fi

echo "03-process: processed $COUNT files into $OUT_DIR"

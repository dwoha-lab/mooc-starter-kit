#!/bin/bash
# run-all.sh — run the four pipeline stages in sequence.
#
# USAGE:
#   ./run-all.sh [source-dir]
#
# Stops at the first failure so you can fix one stage without re-running
# the rest. Each stage prints its own status line.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source dir defaults to sample-docs at repo root. Resolve to an absolute
# path BEFORE we cd, so the path stays valid no matter where we run from.
SOURCE_INPUT="${1:-$SCRIPT_DIR/../../sample-docs}"
if [ -d "$SOURCE_INPUT" ]; then
    SOURCE_ABS="$(cd "$SOURCE_INPUT" && pwd)"
else
    SOURCE_ABS="$SOURCE_INPUT"
fi

# All stages use ./work and ./output relative paths. Anchor them next to
# the scripts so output lands in scripts/pipeline/ regardless of caller cwd.
cd "$SCRIPT_DIR"

./01-fetch.sh   "$SOURCE_ABS"
./02-clean.sh
./03-process.sh
./04-save.sh

echo "run-all: pipeline finished (output in $SCRIPT_DIR/output/)"

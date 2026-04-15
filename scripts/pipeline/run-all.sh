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

"$SCRIPT_DIR/01-fetch.sh"   "${1:-}"
"$SCRIPT_DIR/02-clean.sh"
"$SCRIPT_DIR/03-process.sh"
"$SCRIPT_DIR/04-save.sh"

echo "run-all: pipeline finished"

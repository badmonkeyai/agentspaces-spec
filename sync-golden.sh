#!/usr/bin/env bash
# Copies golden.json (the source) into every consumer's vendored location, then
# checks the copies. Run from anywhere; consumers are located relative to this file.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
root="$(dirname "$here")"
src="$here/golden.json"
copies=(
  "$root/agentspaces/tools/golden/golden.json"
  "$root/agentspaces-python/tests/golden.json"
  "$root/agentspaces-typescript/test/golden.json"
)
for c in "${copies[@]}"; do
  mkdir -p "$(dirname "$c")"
  cp "$src" "$c"
done
for c in "${copies[@]}"; do
  cmp -s "$src" "$c" || { echo "MISMATCH: $c"; exit 1; }
done
echo "golden.json synced to ${#copies[@]} consumers"

#!/usr/bin/env bash
# Copies golden.json (the source) into every consumer's vendored location, then
# checks the copies. Run from anywhere; consumers are located relative to this file.
# The AgentSpaces Rust team owns agentspaces-rust and re-copies golden.json by hand,
# so this script never writes there (neutral vectors, 2026-11-09).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
root="$(dirname "$here")"
src="$here/golden.json"
copies=(
  "$root/agentspaces/tools/golden/golden.json"
  "$root/agentspaces-python/tests/golden.json"
  "$root/agentspaces-typescript/test/golden.json"
  "$root/agentspaces-rb/gems/agentspaces/test/golden.json"
)
for c in "${copies[@]}"; do
  mkdir -p "$(dirname "$c")"
  cp "$src" "$c"
done
for c in "${copies[@]}"; do
  cmp -s "$src" "$c" || { echo "MISMATCH: $c"; exit 1; }
done
echo "golden.json synced to ${#copies[@]} consumers"
# golden-examples.json, the console's non-normative examples, goes to the console's test copy
# (AppCard platform half, 2026-11-09, item 11)
examples="$root/enterprise-platform/bma-console-bridge/src/test/resources/golden-examples.json"
mkdir -p "$(dirname "$examples")"
cp "$here/golden-examples.json" "$examples"
cmp -s "$here/golden-examples.json" "$examples" || { echo "MISMATCH: $examples"; exit 1; }
echo "golden-examples.json synced to the console's test copy"

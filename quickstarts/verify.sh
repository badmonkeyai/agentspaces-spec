#!/bin/bash
# Runs the README's quick start exactly as the README tells a reader to, and prints PASS or FAIL. It also checks that
# the program the README shows is the program in quickstarts/peer_id.py, below its two comment lines.
# Needs Python 3.8 or newer and nothing else.
#
#   quickstarts/verify.sh      (from anywhere)
set -u
cd "$(dirname "$0")/.." || exit 2
shown="$(awk '/^```python/{f=1;next} /^```/{f=0} f' README.md)"
if [ "$shown" != "$(sed -n '3,$p' quickstarts/peer_id.py)" ]; then
  echo "FAIL  README.md shows another program than quickstarts/peer_id.py"; exit 1
fi
out="$(python3 -I quickstarts/peer_id.py golden.json 2>&1)"
if [ $? -eq 0 ] && echo "$out" | grep -q " matches$"; then echo "PASS  peer_id: $out"
else echo "FAIL  peer_id: $out"; exit 1; fi

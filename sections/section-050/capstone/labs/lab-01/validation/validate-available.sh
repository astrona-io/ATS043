#!/usr/bin/env bash
# Check: shuttle and probe are available
set -uo pipefail
fail=0

for d in shuttle probe; do
  ok="$(kubectl -n depot get deployment "$d" -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
  [ "${ok:-0}" -ge 1 ] || { echo "FAIL: $d in depot is not available"; fail=1; }
done

if [ "$fail" -eq 0 ]; then echo "PASS: shuttle and probe are available"; fi
exit "$fail"

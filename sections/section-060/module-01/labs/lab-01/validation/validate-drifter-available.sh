#!/usr/bin/env bash
# Check: drifter in bay is still available
set -uo pipefail
fail=0

ok="$(kubectl -n bay get deployment drifter -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
[ "${ok:-0}" -ge 1 ] || { echo "FAIL: drifter in bay is not available"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: drifter in bay is still available"; fi
exit "$fail"

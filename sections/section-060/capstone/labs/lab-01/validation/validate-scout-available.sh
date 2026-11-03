#!/usr/bin/env bash
# Check: scout in tenant-a is still available
set -uo pipefail
fail=0

ok="$(kubectl -n tenant-a get deployment scout -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
[ "${ok:-0}" -ge 1 ] || { echo "FAIL: scout in tenant-a is not available"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: scout in tenant-a is still available"; fi
exit "$fail"

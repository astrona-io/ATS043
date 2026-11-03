#!/usr/bin/env bash
# Check: Deployment scout in vault is available
set -uo pipefail
fail=0

ok="$(kubectl -n vault get deployment scout -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
if [ "${ok:-0}" -lt 1 ]; then echo "FAIL: scout in vault is not available"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Deployment scout in vault is available"; fi
exit "$fail"

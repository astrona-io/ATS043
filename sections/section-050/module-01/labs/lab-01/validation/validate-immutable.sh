#!/usr/bin/env bash
# Check: Secret db-password is immutable
set -uo pipefail
fail=0

v="$(kubectl -n vault get secret db-password -o jsonpath='{.immutable}' 2>/dev/null)"
if [ "$v" != "true" ]; then echo "FAIL: db-password is not immutable"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Secret db-password is immutable"; fi
exit "$fail"

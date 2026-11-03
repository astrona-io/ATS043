#!/usr/bin/env bash
# Check: Secret db-password holds new-value and the running scout pod reads new-value
set -uo pipefail
fail=0

value="$(kubectl -n vault get secret db-password -o jsonpath='{.data.password}' 2>/dev/null | base64 -d 2>/dev/null)"
if [ "$value" != "new-value" ]; then echo "FAIL: the stored password is not new-value"; fail=1; fi
seen="$(kubectl -n vault exec deploy/scout -- cat /etc/scout/password 2>/dev/null || true)"
if [ "$seen" != "new-value" ]; then echo "FAIL: scout reads '$seen' from /etc/scout/password"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Secret db-password holds new-value and the running scout pod reads new-value"; fi
exit "$fail"

#!/usr/bin/env bash
# Check: api-token and probe-key hold their new values and are immutable
set -uo pipefail
fail=0

check() { # name expected
  value="$(kubectl -n depot get secret "$1" -o jsonpath="{.data.$3}" 2>/dev/null | base64 -d 2>/dev/null)"
  imm="$(kubectl -n depot get secret "$1" -o jsonpath='{.immutable}' 2>/dev/null)"
  [ "$value" = "$2" ] || { echo "FAIL: $1 holds '$value', expected $2"; fail=1; }
  [ "$imm" = "true" ] || { echo "FAIL: $1 is not immutable"; fail=1; }
}
check api-token token-2 token
check probe-key key-2 key

if [ "$fail" -eq 0 ]; then echo "PASS: api-token and probe-key hold their new values and are immutable"; fi
exit "$fail"

#!/usr/bin/env bash
# Check: scout in harbor is still available
set -uo pipefail
fail=0

from() { # NS DEPLOY URL -> prints the HTTP status, 000 when the connection is dropped
  kubectl -n "$1" exec "deploy/$2" -- curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$3" 2>/dev/null
}
allowed() { # NS DEPLOY URL: retries for up to 40 seconds
  local c=""
  for _ in $(seq 1 10); do c="$(from "$1" "$2" "$3")"; [ "$c" = "200" ] && return 0; sleep 4; done
  echo "$c"; return 1
}
ok="$(kubectl -n harbor get deployment scout -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
[ "${ok:-0}" -ge 1 ] || { echo "FAIL: scout in harbor is not available"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: scout in harbor is still available"; fi
exit "$fail"

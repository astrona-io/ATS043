#!/usr/bin/env bash
# Check: shuttle is blocked from probe
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
code="$(from fleet shuttle http://probe.fleet.svc)"
[ "$code" != "200" ] || { echo "FAIL: shuttle can still reach probe"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: shuttle is blocked from probe"; fi
exit "$fail"

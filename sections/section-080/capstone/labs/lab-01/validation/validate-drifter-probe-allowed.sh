#!/usr/bin/env bash
# Check: drifter in outpost reaches probe on port 8080
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
if ! code="$(allowed outpost drifter http://probe.fleet.svc)"; then echo "FAIL: drifter cannot reach probe (status '$code')."; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: drifter in outpost reaches probe on port 8080"; fi
exit "$fail"

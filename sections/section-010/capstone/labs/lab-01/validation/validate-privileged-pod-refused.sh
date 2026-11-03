#!/usr/bin/env bash
# Check: A privileged pod is refused in orbit
set -uo pipefail
fail=0

manifest='{"apiVersion":"v1","kind":"Pod","metadata":{"name":"grader-privileged","namespace":"orbit"},"spec":{"containers":[{"name":"c","image":"mccutchen/go-httpbin:2.25.0","securityContext":{"privileged":true}}]}}'
if echo "$manifest" | kubectl apply --dry-run=server -f - >/dev/null 2>&1; then
  echo "FAIL: a privileged pod was accepted in orbit"
  fail=1
fi

if [ "$fail" -eq 0 ]; then echo "PASS: A privileged pod is refused in orbit"; fi
exit "$fail"

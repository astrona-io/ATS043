#!/usr/bin/env bash
# Check: Both legacy token Secrets in fleet are deleted
set -uo pipefail
fail=0

left="$(kubectl -n fleet get secrets --field-selector type=kubernetes.io/service-account-token -o name 2>/dev/null)"
if [ -n "$left" ]; then echo "FAIL: legacy token Secrets remain: $left"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Both legacy token Secrets in fleet are deleted"; fi
exit "$fail"

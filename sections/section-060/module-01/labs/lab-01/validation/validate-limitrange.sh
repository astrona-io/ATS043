#!/usr/bin/env bash
# Check: LimitRange bay-limits sets default requests and a default memory limit for containers
set -uo pipefail
fail=0

l="$(kubectl -n bay get limitrange bay-limits -o json 2>/dev/null)"
if [ -z "$l" ]; then echo "FAIL: LimitRange bay-limits does not exist in bay"; exit 1; fi
c="$(echo "$l" | jq -c '[.spec.limits[] | select(.type == "Container")][0] // {}')"
get() { echo "$c" | jq -r "$1 // \"\""; }
[ "$(get .defaultRequest.cpu)" = "50m" ] || { echo "FAIL: defaultRequest.cpu is not 50m"; fail=1; }
[ "$(get .defaultRequest.memory)" = "32Mi" ] || { echo "FAIL: defaultRequest.memory is not 32Mi"; fail=1; }
[ "$(get .default.memory)" = "128Mi" ] || { echo "FAIL: default.memory is not 128Mi"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: LimitRange bay-limits sets default requests and a default memory limit for containers"; fi
exit "$fail"

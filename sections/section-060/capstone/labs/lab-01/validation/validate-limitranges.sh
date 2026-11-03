#!/usr/bin/env bash
# Check: Both tenants have a LimitRange tenant-limits with default requests and a default memory limit
set -uo pipefail
fail=0

for ns in tenant-a tenant-b; do
  l="$(kubectl -n "$ns" get limitrange tenant-limits -o json 2>/dev/null)"
  if [ -z "$l" ]; then echo "FAIL: LimitRange tenant-limits does not exist in $ns"; fail=1; continue; fi
  c="$(echo "$l" | jq -c '[.spec.limits[] | select(.type == "Container")][0] // {}')"
  get() { echo "$c" | jq -r "$1 // \"\""; }
  [ "$(get .defaultRequest.cpu)" = "50m" ] || { echo "FAIL: $ns defaultRequest.cpu is not 50m"; fail=1; }
  [ "$(get .defaultRequest.memory)" = "32Mi" ] || { echo "FAIL: $ns defaultRequest.memory is not 32Mi"; fail=1; }
  [ "$(get .default.memory)" = "128Mi" ] || { echo "FAIL: $ns default.memory is not 128Mi"; fail=1; }
done

if [ "$fail" -eq 0 ]; then echo "PASS: Both tenants have a LimitRange tenant-limits with default requests and a default memory limit"; fi
exit "$fail"

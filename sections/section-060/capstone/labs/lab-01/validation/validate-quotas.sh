#!/usr/bin/env bash
# Check: Both tenants have a ResourceQuota tenant-quota with the required limits
set -uo pipefail
fail=0

chk_ns() {
  ns="$1"; shift
  q="$(kubectl -n "$ns" get resourcequota tenant-quota -o json 2>/dev/null)"
  if [ -z "$q" ]; then echo "FAIL: ResourceQuota tenant-quota does not exist in $ns"; fail=1; return; fi
  while [ $# -gt 1 ]; do
    v="$(echo "$q" | jq -r --arg k "$1" '.spec.hard[$k] // ""')"
    [ "$v" = "$2" ] || { echo "FAIL: $ns hard $1 is '$v', expected $2"; fail=1; }
    shift 2
  done
}
chk_ns tenant-a pods 5 requests.cpu 500m requests.memory 512Mi limits.memory 1Gi
chk_ns tenant-b pods 3 requests.cpu 250m requests.memory 256Mi limits.memory 512Mi

if [ "$fail" -eq 0 ]; then echo "PASS: Both tenants have a ResourceQuota tenant-quota with the required limits"; fi
exit "$fail"

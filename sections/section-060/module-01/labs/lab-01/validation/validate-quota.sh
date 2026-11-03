#!/usr/bin/env bash
# Check: ResourceQuota bay-quota limits pods, requests and memory limits in bay
set -uo pipefail
fail=0

q="$(kubectl -n bay get resourcequota bay-quota -o json 2>/dev/null)"
if [ -z "$q" ]; then echo "FAIL: ResourceQuota bay-quota does not exist in bay"; exit 1; fi
chk_hard() { v="$(echo "$q" | jq -r --arg k "$1" '.spec.hard[$k] // ""')"; if [ "$v" != "$2" ]; then echo "FAIL: hard $1 is '$v', expected $2"; fail=1; fi; }
chk_hard pods 6
chk_hard requests.cpu 1
chk_hard requests.memory 1Gi
chk_hard limits.memory 2Gi

if [ "$fail" -eq 0 ]; then echo "PASS: ResourceQuota bay-quota limits pods, requests and memory limits in bay"; fi
exit "$fail"

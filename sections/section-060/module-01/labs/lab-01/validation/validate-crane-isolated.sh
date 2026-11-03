#!/usr/bin/env bash
# Check: crane in bay no longer shares the host PID namespace and is available
set -uo pipefail
fail=0

host="$(kubectl -n bay get deployment crane -o jsonpath='{.spec.template.spec.hostPID}' 2>/dev/null)"
[ "$host" != "true" ] || { echo "FAIL: crane still sets hostPID"; fail=1; }
bad="$(kubectl -n bay get pods -l app=crane -o json | jq -r '.items[] | select(.metadata.deletionTimestamp == null and .spec.hostPID == true) | .metadata.name')"
[ -z "$bad" ] || { echo "FAIL: pods still use hostPID: $bad"; fail=1; }
ok="$(kubectl -n bay get deployment crane -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
[ "${ok:-0}" -ge 1 ] || { echo "FAIL: crane is not available"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: crane in bay no longer shares the host PID namespace and is available"; fi
exit "$fail"

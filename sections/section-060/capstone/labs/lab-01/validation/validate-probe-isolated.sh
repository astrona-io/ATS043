#!/usr/bin/env bash
# Check: probe in tenant-b shares no host PID namespace or host path and is available
set -uo pipefail
fail=0

t='.spec.template.spec'
[ "$(kubectl -n tenant-b get deployment probe -o jsonpath='{.spec.template.spec.hostPID}' 2>/dev/null)" != "true" ] || { echo "FAIL: probe still sets hostPID"; fail=1; }
hp="$(kubectl -n tenant-b get deployment probe -o json | jq '[(.spec.template.spec.volumes // [])[] | select(.hostPath != null)] | length')"
[ "${hp:-1}" -eq 0 ] || { echo "FAIL: probe still mounts a hostPath volume"; fail=1; }
bad="$(kubectl -n tenant-b get pods -l app=probe -o json | jq -r '.items[] | select(.metadata.deletionTimestamp == null and (.spec.hostPID == true or any((.spec.volumes // [])[]; .hostPath != null))) | .metadata.name')"
[ -z "$bad" ] || { echo "FAIL: pods still share the host: $bad"; fail=1; }
ok="$(kubectl -n tenant-b get deployment probe -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
[ "${ok:-0}" -ge 1 ] || { echo "FAIL: probe is not available"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: probe in tenant-b shares no host PID namespace or host path and is available"; fi
exit "$fail"

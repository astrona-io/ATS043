#!/usr/bin/env bash
# Check: Every pod of batch in beta runs and meets the baseline level
set -uo pipefail
fail=0

baseline_pods() {
  local ns="$1" app="$2" pods count bad
  pods="$(kubectl -n "$ns" get pods -l "app=$app" -o json 2>/dev/null)"
  count="$(echo "$pods" | jq "[.items[] | select(.metadata.deletionTimestamp == null)] | length")"
  if [ "${count:-0}" -lt 1 ]; then echo "FAIL: no pod of $app is running in $ns"; return 1; fi
  bad="$(echo "$pods" | jq -r ".items[] | select(.metadata.deletionTimestamp == null) | . as \$pod
    | select(
        (\$pod.status.phase != \"Running\")
        or ((\$pod.spec.hostNetwork // false) or (\$pod.spec.hostPID // false) or (\$pod.spec.hostIPC // false))
        or (any((\$pod.spec.volumes // [])[]; .hostPath != null))
        or (any(\$pod.spec.containers[]; (.securityContext.privileged == true)))
      ) | .metadata.name")"
  if [ -n "$bad" ]; then echo "FAIL: pods of $app do not meet the baseline level or are not Running: $bad"; return 1; fi
  return 0
}
baseline_pods beta batch || fail=1

if [ "$fail" -eq 0 ]; then echo "PASS: Every pod of batch in beta runs and meets the baseline level"; fi
exit "$fail"

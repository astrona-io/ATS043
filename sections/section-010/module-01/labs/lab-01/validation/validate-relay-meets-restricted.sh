#!/usr/bin/env bash
# Check: Every pod of relay runs and meets the restricted level
set -uo pipefail
fail=0

restricted_pods() {
  local ns="$1" app="$2" pods count bad
  pods="$(kubectl -n "$ns" get pods -l "app=$app" -o json 2>/dev/null)"
  count="$(echo "$pods" | jq "[.items[] | select(.metadata.deletionTimestamp == null)] | length")"
  if [ "${count:-0}" -lt 1 ]; then echo "FAIL: no pod of $app is running in $ns"; return 1; fi
  bad="$(echo "$pods" | jq -r ".items[] | select(.metadata.deletionTimestamp == null) | . as \$pod
    | (\$pod.spec.securityContext // {}) as \$p
    | select(
        (\$pod.status.phase != \"Running\")
        or ((\$pod.spec.hostNetwork // false) or (\$pod.spec.hostPID // false) or (\$pod.spec.hostIPC // false))
        or (any((\$pod.spec.volumes // [])[]; .hostPath != null))
        or (any(\$pod.spec.containers[]; . as \$c | (\$c.securityContext // {}) as \$s
            | (\$s.privileged == true)
              or ((\$s.runAsNonRoot // \$p.runAsNonRoot) != true)
              or ((\$s.runAsUser // \$p.runAsUser // 1) == 0)
              or (\$s.allowPrivilegeEscalation != false)
              or (((\$s.capabilities.drop // []) | index(\"ALL\")) == null)
              or (((\$s.capabilities.add // []) - [\"NET_BIND_SERVICE\"]) | length > 0)
              or ((\$s.seccompProfile.type // \$p.seccompProfile.type) as \$t | (\$t != \"RuntimeDefault\" and \$t != \"Localhost\"))))
      ) | .metadata.name")"
  if [ -n "$bad" ]; then echo "FAIL: pods of $app do not meet the restricted level or are not Running: $bad"; return 1; fi
  return 0
}
restricted_pods hangar relay || fail=1

if [ "$fail" -eq 0 ]; then echo "PASS: Every pod of relay runs and meets the restricted level"; fi
exit "$fail"

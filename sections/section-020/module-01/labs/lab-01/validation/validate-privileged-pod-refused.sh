#!/usr/bin/env bash
# Check: A privileged pod is refused in dock
set -uo pipefail
fail=0

dry_run_pod() { # namespace, name, json for spec fields besides containers (may be empty object), container securityContext json
  local ns="$1" name="$2" spec="$3" sc="$4"
  echo "{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"name\":\"$name\",\"namespace\":\"$ns\"},\"spec\":$(echo "$spec" | jq -c ". + {containers:[{name:\"c\",image:\"mccutchen/go-httpbin:2.25.0\",securityContext:$sc}]}")}" | kubectl apply --dry-run=server -f - >/dev/null 2>&1
}
if dry_run_pod dock grader-privileged '{}' '{"privileged":true}'; then
  echo "FAIL: a privileged pod was accepted in dock"
  fail=1
fi

if [ "$fail" -eq 0 ]; then echo "PASS: A privileged pod is refused in dock"; fi
exit "$fail"

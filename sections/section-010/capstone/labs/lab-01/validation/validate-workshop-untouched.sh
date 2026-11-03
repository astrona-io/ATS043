#!/usr/bin/env bash
# Check: workshop still runs tools and does not enforce baseline or restricted
set -uo pipefail
fail=0

for mode in enforce; do
  value="$(kubectl get namespace workshop -o json | jq -r --arg k "pod-security.kubernetes.io/$mode" '.metadata.labels[$k] // ""')"
  if [ "$value" = "baseline" ] || [ "$value" = "restricted" ]; then
    echo "FAIL: workshop enforces $value"
    fail=1
  fi
done
ready="$(kubectl -n workshop get deployment tools -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
if [ "${ready:-0}" -lt 1 ]; then echo "FAIL: deployment tools in workshop is not available"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: workshop still runs tools and does not enforce baseline or restricted"; fi
exit "$fail"

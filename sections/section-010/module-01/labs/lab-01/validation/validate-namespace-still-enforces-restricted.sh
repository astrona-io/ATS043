#!/usr/bin/env bash
# Check: The hangar namespace still enforces the restricted level
set -uo pipefail
fail=0

level="$(kubectl get namespace hangar -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' 2>/dev/null)"
if [ "$level" != "restricted" ]; then
  echo "FAIL: pod-security.kubernetes.io/enforce on hangar is '$level', expected restricted"
  fail=1
fi

if [ "$fail" -eq 0 ]; then echo "PASS: The hangar namespace still enforces the restricted level"; fi
exit "$fail"

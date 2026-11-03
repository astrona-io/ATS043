#!/usr/bin/env bash
# Check: alpha enforces restricted at v1.35 and the misspelled label is gone
set -uo pipefail
fail=0

get_label() { kubectl get namespace alpha -o json | jq -r --arg k "$1" '.metadata.labels[$k] // ""'; }
expect() { value="$(get_label "$1")"; if [ "$value" != "$2" ]; then echo "FAIL: $1 is '$value', expected $2"; fail=1; fi; }
expect pod-security.kubernetes.io/enforce restricted
expect pod-security.kubernetes.io/enforce-version v1.35
if [ -n "$(get_label pod-security.kubernetes.io/enforc)" ]; then echo "FAIL: the misspelled label enforc is still present"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: alpha enforces restricted at v1.35 and the misspelled label is gone"; fi
exit "$fail"

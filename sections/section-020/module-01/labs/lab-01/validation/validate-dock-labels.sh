#!/usr/bin/env bash
# Check: dock enforces baseline (version v1.35) and warns and audits restricted
set -uo pipefail
fail=0

get_label() { kubectl get namespace dock -o json | jq -r --arg k "$1" '.metadata.labels[$k] // ""'; }
expect() { value="$(get_label "$1")"; if [ "$value" != "$2" ]; then echo "FAIL: $1 is '$value', expected $2"; fail=1; fi; }
expect pod-security.kubernetes.io/enforce baseline
expect pod-security.kubernetes.io/enforce-version v1.35
expect pod-security.kubernetes.io/warn restricted
expect pod-security.kubernetes.io/audit restricted

if [ "$fail" -eq 0 ]; then echo "PASS: dock enforces baseline (version v1.35) and warns and audits restricted"; fi
exit "$fail"

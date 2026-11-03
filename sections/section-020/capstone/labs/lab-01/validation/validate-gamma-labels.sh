#!/usr/bin/env bash
# Check: gamma warns and audits baseline and has no enforce label
set -uo pipefail
fail=0

get_label() { kubectl get namespace gamma -o json | jq -r --arg k "$1" '.metadata.labels[$k] // ""'; }
expect() { value="$(get_label "$1")"; if [ "$value" != "$2" ]; then echo "FAIL: $1 is '$value', expected $2"; fail=1; fi; }
expect pod-security.kubernetes.io/warn baseline
expect pod-security.kubernetes.io/audit baseline
if [ -n "$(get_label pod-security.kubernetes.io/enforce)" ]; then echo "FAIL: gamma must not enforce a level"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: gamma warns and audits baseline and has no enforce label"; fi
exit "$fail"

#!/usr/bin/env bash
# Check: orbit enforces, warns and audits restricted with a pinned enforce version
set -uo pipefail
fail=0

get_label() { kubectl get namespace orbit -o json | jq -r --arg k "$1" '.metadata.labels[$k] // ""'; }
for mode in enforce warn audit; do
  value="$(get_label "pod-security.kubernetes.io/$mode")"
  if [ "$value" != "restricted" ]; then echo "FAIL: pod-security.kubernetes.io/$mode is '$value', expected restricted"; fail=1; fi
done
version="$(get_label pod-security.kubernetes.io/enforce-version)"
if [ "$version" != "v1.35" ]; then echo "FAIL: pod-security.kubernetes.io/enforce-version is '$version', expected v1.35"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: orbit enforces, warns and audits restricted with a pinned enforce version"; fi
exit "$fail"

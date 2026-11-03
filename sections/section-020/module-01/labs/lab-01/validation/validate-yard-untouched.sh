#!/usr/bin/env bash
# Check: yard has no enforce label and forklift still runs
set -uo pipefail
fail=0

labels="$(kubectl get namespace yard -o json | jq -r '.metadata.labels | keys[]' | grep '^pod-security' || true)"
if [ -n "$labels" ]; then echo "FAIL: yard has Pod Security labels: $labels"; fail=1; fi
privileged="$(kubectl -n yard get deployment forklift -o jsonpath='{.spec.template.spec.containers[0].securityContext.privileged}' 2>/dev/null)"
available="$(kubectl -n yard get deployment forklift -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
if [ "$privileged" != "true" ] || [ "${available:-0}" -lt 1 ]; then echo "FAIL: forklift in yard was changed or is not available"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: yard has no enforce label and forklift still runs"; fi
exit "$fail"

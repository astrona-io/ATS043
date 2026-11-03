#!/usr/bin/env bash
# Check: agent in gamma still runs privileged with hostNetwork
set -uo pipefail
fail=0

net="$(kubectl -n gamma get deployment agent -o jsonpath='{.spec.template.spec.hostNetwork}' 2>/dev/null)"
priv="$(kubectl -n gamma get deployment agent -o jsonpath='{.spec.template.spec.containers[0].securityContext.privileged}' 2>/dev/null)"
ok="$(kubectl -n gamma get deployment agent -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
if [ "$net" != "true" ] || [ "$priv" != "true" ] || [ "${ok:-0}" -lt 1 ]; then echo "FAIL: agent in gamma was changed or is not available"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: agent in gamma still runs privileged with hostNetwork"; fi
exit "$fail"

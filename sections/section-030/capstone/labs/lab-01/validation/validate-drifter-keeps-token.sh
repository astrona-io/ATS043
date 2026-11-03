#!/usr/bin/env bash
# Check: drifter still mounts a token and is available
set -uo pipefail
fail=0

pods="$(kubectl -n fleet get pods -l app=drifter -o json 2>/dev/null)"
n="$(echo "$pods" | jq '[.items[] | select(.metadata.deletionTimestamp == null and .status.phase == "Running" and (any((.spec.volumes // [])[]; (.projected.sources // []) | any(.serviceAccountToken != null))))] | length')"
if [ "${n:-0}" -lt 1 ]; then echo "FAIL: no running drifter pod has a ServiceAccount token volume"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: drifter still mounts a token and is available"; fi
exit "$fail"

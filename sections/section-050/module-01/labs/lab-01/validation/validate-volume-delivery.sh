#!/usr/bin/env bash
# Check: scout gets the password from a read-only Secret volume at /etc/scout and has no secret environment variable
set -uo pipefail
fail=0

dep="$(kubectl -n vault get deployment scout -o json 2>/dev/null)"
env_refs="$(echo "$dep" | jq '[.spec.template.spec.containers[].env[]? | select(.valueFrom.secretKeyRef != null)] | length')"
from_refs="$(echo "$dep" | jq '[.spec.template.spec.containers[].envFrom[]? | select(.secretRef != null)] | length')"
[ "${env_refs:-1}" -eq 0 ] && [ "${from_refs:-1}" -eq 0 ] || { echo "FAIL: scout still takes a Secret through environment variables"; fail=1; }
mount="$(echo "$dep" | jq -r '[.spec.template.spec.containers[0].volumeMounts[]? | select(.mountPath == "/etc/scout")][0] | if . == null then "missing" else ((.readOnly // false | tostring) + "," + (.subPath // "")) end')"
if [ "$mount" != "true," ]; then echo "FAIL: /etc/scout mount is '$mount'; expected a read-only mount without subPath"; fail=1; fi
vol="$(echo "$dep" | jq -r '[.spec.template.spec.volumes[]? | select(.secret.secretName == "db-password")] | length')"
[ "${vol:-0}" -ge 1 ] || { echo "FAIL: no volume uses Secret db-password"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: scout gets the password from a read-only Secret volume at /etc/scout and has no secret environment variable"; fi
exit "$fail"

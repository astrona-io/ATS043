#!/usr/bin/env bash
# Check: shuttle reads token-2 from a read-only volume at /etc/shuttle and has no secret environment variable
set -uo pipefail
fail=0

dep="$(kubectl -n depot get deployment shuttle -o json 2>/dev/null)"
n="$(echo "$dep" | jq '[.spec.template.spec.containers[] | (.env[]? | select(.valueFrom.secretKeyRef != null)), (.envFrom[]? | select(.secretRef != null))] | length')"
[ "${n:-1}" -eq 0 ] || { echo "FAIL: shuttle still takes a Secret through environment variables"; fail=1; }
mount="$(echo "$dep" | jq -r '[.spec.template.spec.containers[0].volumeMounts[]? | select(.mountPath == "/etc/shuttle")][0] | if . == null then "missing" else ((.readOnly // false | tostring) + "," + (.subPath // "")) end')"
[ "$mount" = "true," ] || { echo "FAIL: /etc/shuttle mount is '$mount'; expected read-only without subPath"; fail=1; }
seen="$(kubectl -n depot exec deploy/shuttle -- cat /etc/shuttle/token 2>/dev/null || true)"
[ "$seen" = "token-2" ] || { echo "FAIL: shuttle reads '$seen' from /etc/shuttle/token"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: shuttle reads token-2 from a read-only volume at /etc/shuttle and has no secret environment variable"; fi
exit "$fail"

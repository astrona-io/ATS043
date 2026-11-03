#!/usr/bin/env bash
# Check: probe mounts probe-key without subPath and reads key-2
set -uo pipefail
fail=0

dep="$(kubectl -n depot get deployment probe -o json 2>/dev/null)"
sp="$(echo "$dep" | jq -r '[.spec.template.spec.containers[0].volumeMounts[]? | select(.subPath != null and .subPath != "")] | length')"
[ "${sp:-1}" -eq 0 ] || { echo "FAIL: probe still mounts a Secret with subPath"; fail=1; }
seen="$(kubectl -n depot exec deploy/probe -- sh -c 'cat /etc/probe/key/key 2>/dev/null || cat /etc/probe/key' 2>/dev/null || true)"
[ "$seen" = "key-2" ] || { echo "FAIL: probe reads '$seen' for the key"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: probe mounts probe-key without subPath and reads key-2"; fi
exit "$fail"

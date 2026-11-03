#!/usr/bin/env bash
# Check: A Pod without resources gets the defaults and a Pod over the quota is refused
set -uo pipefail
fail=0

out="$(cat <<'YAML' | kubectl -n bay create --dry-run=server -o json -f - 2>/dev/null
{"apiVersion":"v1","kind":"Pod","metadata":{"name":"grader-plain"},"spec":{"containers":[{"name":"c","image":"curlimages/curl:8.22.0"}]}}
YAML
)"
mem="$(echo "$out" | jq -r '.spec.containers[0].resources.limits.memory // ""' 2>/dev/null)"
[ "$mem" = "128Mi" ] || { echo "FAIL: a Pod with no resources gets memory limit '$mem', expected 128Mi"; fail=1; }
if cat <<'YAML' | kubectl -n bay create --dry-run=server -f - >/dev/null 2>&1
{"apiVersion":"v1","kind":"Pod","metadata":{"name":"grader-big"},"spec":{"containers":[{"name":"c","image":"curlimages/curl:8.22.0","resources":{"requests":{"cpu":"4","memory":"32Mi"},"limits":{"memory":"64Mi"}}}]}}
YAML
then echo "FAIL: a Pod requesting 4 CPUs was accepted in bay"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: A Pod without resources gets the defaults and a Pod over the quota is refused"; fi
exit "$fail"

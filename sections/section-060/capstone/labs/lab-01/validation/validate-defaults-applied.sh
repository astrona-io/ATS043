#!/usr/bin/env bash
# Check: A Pod without resources gets the memory default in both tenants
set -uo pipefail
fail=0

for ns in tenant-a tenant-b; do
  out="$(cat <<'YAML' | kubectl -n "$ns" create --dry-run=server -o json -f - 2>/dev/null
{"apiVersion":"v1","kind":"Pod","metadata":{"name":"grader-plain"},"spec":{"containers":[{"name":"c","image":"curlimages/curl:8.22.0"}]}}
YAML
)"
  mem="$(echo "$out" | jq -r '.spec.containers[0].resources.limits.memory // ""' 2>/dev/null)"
  [ "$mem" = "128Mi" ] || { echo "FAIL: in $ns a Pod with no resources gets memory limit '$mem', expected 128Mi"; fail=1; }
done

if [ "$fail" -eq 0 ]; then echo "PASS: A Pod without resources gets the memory default in both tenants"; fi
exit "$fail"

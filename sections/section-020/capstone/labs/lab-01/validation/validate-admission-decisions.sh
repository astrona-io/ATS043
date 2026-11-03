#!/usr/bin/env bash
# Check: Privileged and hostNetwork pods are refused where enforced and gamma stays open
set -uo pipefail
fail=0

dry_run_pod() { # namespace, name, json for spec fields besides containers (may be empty object), container securityContext json
  local ns="$1" name="$2" spec="$3" sc="$4"
  echo "{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"name\":\"$name\",\"namespace\":\"$ns\"},\"spec\":$(echo "$spec" | jq -c ". + {containers:[{name:\"c\",image:\"mccutchen/go-httpbin:2.25.0\",securityContext:$sc}]}")}" | kubectl apply --dry-run=server -f - >/dev/null 2>&1
}
if dry_run_pod alpha g-priv '{}' '{"privileged":true}'; then echo "FAIL: privileged pod accepted in alpha"; fail=1; fi
if dry_run_pod beta g-priv '{}' '{"privileged":true}'; then echo "FAIL: privileged pod accepted in beta"; fail=1; fi
if dry_run_pod beta g-host '{"hostNetwork":true}' '{}'; then echo "FAIL: hostNetwork pod accepted in beta"; fail=1; fi
if ! dry_run_pod gamma g-priv '{}' '{"privileged":true}'; then echo "FAIL: gamma must still accept a privileged pod"; fail=1; fi
if ! dry_run_pod beta g-plain '{}' '{}'; then echo "FAIL: a baseline pod was refused in beta"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Privileged and hostNetwork pods are refused where enforced and gamma stays open"; fi
exit "$fail"

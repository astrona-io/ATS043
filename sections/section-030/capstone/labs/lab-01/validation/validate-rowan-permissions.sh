#!/usr/bin/env bash
# Check: rowan can list pods in fleet and cannot delete them
set -uo pipefail
fail=0

yes_list="$(kubectl auth can-i list pods -n fleet --as=rowan --as-group=cadets 2>/dev/null || true)"
no_delete="$(kubectl auth can-i delete pods -n fleet --as=rowan --as-group=cadets 2>/dev/null || true)"
no_secrets="$(kubectl auth can-i get secrets -n fleet --as=rowan --as-group=cadets 2>/dev/null || true)"
[ "$yes_list" = "yes" ] || { echo "FAIL: rowan cannot list pods in fleet"; fail=1; }
[ "$no_delete" = "no" ] || { echo "FAIL: rowan can delete pods in fleet"; fail=1; }
[ "$no_secrets" = "no" ] || { echo "FAIL: rowan can read secrets in fleet"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: rowan can list pods in fleet and cannot delete them"; fi
exit "$fail"

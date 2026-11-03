#!/usr/bin/env bash
# Check: tenant-b ops-sa has no access in tenant-a but keeps edit in tenant-b
set -uo pipefail
fail=0

if kubectl -n tenant-a get rolebinding shared-edit >/dev/null 2>&1; then echo "FAIL: RoleBinding shared-edit still exists in tenant-a"; fail=1; fi
a="$(kubectl auth can-i create deployments -n tenant-a --as=system:serviceaccount:tenant-b:ops-sa 2>/dev/null)"
[ "$a" = "no" ] || { echo "FAIL: ops-sa from tenant-b can still create deployments in tenant-a"; fail=1; }
b="$(kubectl auth can-i create deployments -n tenant-b --as=system:serviceaccount:tenant-b:ops-sa 2>/dev/null)"
[ "$b" = "yes" ] || { echo "FAIL: ops-sa lost edit access in tenant-b"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: tenant-b ops-sa has no access in tenant-a but keeps edit in tenant-b"; fi
exit "$fail"

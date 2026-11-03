#!/usr/bin/env bash
# Check: CSR intruder-csr is denied and has no certificate
set -uo pipefail
fail=0

cert="$(kubectl get csr intruder-csr -o jsonpath='{.status.certificate}' 2>/dev/null)"
denied="$(kubectl get csr intruder-csr -o jsonpath='{.status.conditions[?(@.type=="Denied")].type}' 2>/dev/null)"
if [ -n "$cert" ]; then echo "FAIL: intruder-csr was issued a certificate"; fail=1; fi
if [ "$denied" != "Denied" ]; then echo "FAIL: intruder-csr is not denied"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: CSR intruder-csr is denied and has no certificate"; fi
exit "$fail"

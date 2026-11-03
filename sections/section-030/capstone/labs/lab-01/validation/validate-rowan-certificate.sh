#!/usr/bin/env bash
# Check: CSR rowan-csr is approved with CN=rowan, O=cadets
set -uo pipefail
fail=0

cert="$(kubectl get csr rowan-csr -o jsonpath='{.status.certificate}' 2>/dev/null)"
if [ -z "$cert" ]; then echo "FAIL: CSR rowan-csr has no issued certificate"; fail=1
else
  subject="$(echo "$cert" | base64 -d | openssl x509 -noout -subject -nameopt compat 2>/dev/null)"
  echo "$subject" | grep -Eq 'CN *= *rowan' || { echo "FAIL: subject is '$subject'"; fail=1; }
  echo "$subject" | grep -Eq 'O *= *cadets' || { echo "FAIL: subject has no O=cadets: '$subject'"; fail=1; }
fi

if [ "$fail" -eq 0 ]; then echo "PASS: CSR rowan-csr is approved with CN=rowan, O=cadets"; fi
exit "$fail"

#!/usr/bin/env bash
# Check: The unused Secrets old-api-token and spare-ssh-key are deleted and used Secrets remain
set -uo pipefail
fail=0

for s in old-api-token spare-ssh-key; do
  if kubectl -n depot get secret "$s" >/dev/null 2>&1; then echo "FAIL: unused Secret $s still exists"; fail=1; fi
done
for s in api-token probe-key; do
  kubectl -n depot get secret "$s" >/dev/null 2>&1 || { echo "FAIL: Secret $s was deleted but is in use"; fail=1; }
done

if [ "$fail" -eq 0 ]; then echo "PASS: The unused Secrets old-api-token and spare-ssh-key are deleted and used Secrets remain"; fi
exit "$fail"

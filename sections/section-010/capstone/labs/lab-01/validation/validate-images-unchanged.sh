#!/usr/bin/env bash
# Check: The three Deployments in orbit keep their images
set -uo pipefail
fail=0

expect() {
  image="$(kubectl -n orbit get deployment "$1" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
  if [ "$image" != "$2" ]; then echo "FAIL: deployment $1 image is '$image', expected $2"; fail=1; fi
}
expect beacon ghcr.io/stefanprodan/podinfo:6.15.0
expect relay mccutchen/go-httpbin:2.25.0
expect cargo ghcr.io/stefanprodan/podinfo:6.15.0

if [ "$fail" -eq 0 ]; then echo "PASS: The three Deployments in orbit keep their images"; fi
exit "$fail"

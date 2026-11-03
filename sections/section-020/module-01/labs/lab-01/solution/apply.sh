#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl -n dock patch deployment tug --type=json -p '[{"op":"remove","path":"/spec/template/spec/containers/0/securityContext/privileged"}]'
kubectl label namespace dock \
  pod-security.kubernetes.io/enforce=baseline \
  pod-security.kubernetes.io/enforce-version=v1.35 \
  pod-security.kubernetes.io/warn=restricted \
  pod-security.kubernetes.io/audit=restricted --overwrite
kubectl -n dock rollout status deployment/tug --timeout=180s
echo "[solution] Applied."

#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl label namespace alpha pod-security.kubernetes.io/enforc- 
kubectl label namespace alpha pod-security.kubernetes.io/enforce=restricted pod-security.kubernetes.io/enforce-version=v1.35 --overwrite
kubectl label namespace beta pod-security.kubernetes.io/enforce=baseline pod-security.kubernetes.io/warn=restricted pod-security.kubernetes.io/audit=restricted --overwrite
kubectl label namespace gamma pod-security.kubernetes.io/warn=baseline pod-security.kubernetes.io/audit=baseline --overwrite
kubectl -n beta patch deployment batch --type=json -p '[{"op":"remove","path":"/spec/template/spec/containers/0/securityContext/privileged"}]'
kubectl -n alpha patch deployment web --type=strategic -p '{"spec":{"template":{"spec":{"securityContext":{"runAsNonRoot":true,"runAsUser":10001,"seccompProfile":{"type":"RuntimeDefault"}},"containers":[{"name":"web","securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}}]}}}}'
kubectl -n alpha rollout status deployment/web --timeout=180s
kubectl -n beta rollout status deployment/batch --timeout=180s
echo "[solution] Applied."

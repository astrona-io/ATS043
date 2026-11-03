#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl certificate approve rowan-csr
kubectl certificate deny intruder-csr
kubectl -n fleet create rolebinding rowan-view --clusterrole=view --user=rowan
kubectl -n fleet patch serviceaccount shuttle-sa --type=merge -p '{"automountServiceAccountToken":false}'
kubectl -n fleet delete secret shuttle-sa-token drifter-sa-token
kubectl -n fleet rollout restart deployment/shuttle
kubectl -n fleet rollout status deployment/shuttle --timeout=180s
for _ in $(seq 1 30); do
  [ -n "$(kubectl get csr rowan-csr -o jsonpath='{.status.certificate}')" ] && break
  sleep 2
done
echo "[solution] Applied."

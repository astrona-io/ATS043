#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Replace the hardened parts of relay and cargo that apply cannot remove by merge.
kubectl -n orbit patch deployment cargo --type=json -p '[{"op":"remove","path":"/spec/template/spec/hostPID"}]' || true
kubectl apply -f "$DIR/solution.yaml"
kubectl label namespace orbit \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/enforce-version=v1.35 \
  pod-security.kubernetes.io/warn=restricted \
  pod-security.kubernetes.io/audit=restricted --overwrite
for name in beacon relay cargo; do
  kubectl -n orbit rollout status "deployment/$name" --timeout=180s
done
echo "[solution] Applied."

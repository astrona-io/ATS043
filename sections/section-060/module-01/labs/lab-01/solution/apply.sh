#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/solution.yaml"
kubectl -n bay patch deployment crane --type=json -p '[{"op":"remove","path":"/spec/template/spec/hostPID"}]'
kubectl -n bay rollout status deployment/crane --timeout=180s
echo "[solution] Applied."

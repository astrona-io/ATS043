#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/solution.yaml"
kubectl -n tenant-a delete rolebinding shared-edit
kubectl -n tenant-b patch deployment probe --type=json -p '[
  {"op":"remove","path":"/spec/template/spec/hostPID"},
  {"op":"remove","path":"/spec/template/spec/volumes"},
  {"op":"remove","path":"/spec/template/spec/containers/0/volumeMounts"}]'
kubectl -n tenant-b rollout status deployment/probe --timeout=180s
echo "[solution] Applied."

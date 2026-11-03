#!/usr/bin/env bash
# Starting state. Environment only: it creates objects and faults, never the learner's answer.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n bay rollout status deployment/drifter --timeout=180s
kubectl -n bay rollout status deployment/crane --timeout=180s
echo "[lab] Ready."

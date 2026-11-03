#!/usr/bin/env bash
# Starting state. Environment only: it creates objects and faults, never the learner's answer.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n alpha rollout status deployment/web --timeout=180s
kubectl -n beta rollout status deployment/batch --timeout=180s
kubectl -n gamma rollout status deployment/agent --timeout=180s
echo "[lab] Ready."

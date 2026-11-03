#!/usr/bin/env bash
# Starting state. Environment only: it creates objects and faults, never the learner's answer.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n dock rollout status deployment/tug --timeout=180s
kubectl -n dock rollout status deployment/crane --timeout=180s
kubectl -n yard rollout status deployment/forklift --timeout=180s
echo "[lab] Ready."

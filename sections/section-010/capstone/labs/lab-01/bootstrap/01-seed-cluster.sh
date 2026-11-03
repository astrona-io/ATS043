#!/usr/bin/env bash
# Starting state. Environment only: it creates objects and faults, never the learner's answer.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n orbit rollout status deployment/beacon --timeout=180s
kubectl -n orbit rollout status deployment/relay --timeout=180s
kubectl -n orbit rollout status deployment/cargo --timeout=180s
kubectl -n workshop rollout status deployment/tools --timeout=180s
echo "[lab] Ready."

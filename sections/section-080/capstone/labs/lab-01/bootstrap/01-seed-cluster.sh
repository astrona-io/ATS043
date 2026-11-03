#!/usr/bin/env bash
# Starting state. Environment only: it creates objects and faults, never the learner's answer.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n fleet rollout status deployment/scout --timeout=180s
kubectl -n fleet rollout status deployment/probe --timeout=180s
kubectl -n fleet rollout status deployment/shuttle --timeout=180s
kubectl -n fleet rollout status deployment/crane --timeout=180s
kubectl -n outpost rollout status deployment/drifter --timeout=180s
kubectl -n outpost rollout status deployment/intruder --timeout=180s
kubectl -n outpost rollout status deployment/beacon --timeout=180s
echo "[lab] Ready."

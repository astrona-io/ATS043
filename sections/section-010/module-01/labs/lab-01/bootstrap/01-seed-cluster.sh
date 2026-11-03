#!/usr/bin/env bash
# Starting state. Environment only: the Deployments run first, then the
# restricted level is enforced on the namespace. Existing pods keep running;
# every new pod must meet the level.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
for name in fuel cargo relay; do
  kubectl -n hangar rollout status "deployment/$name" --timeout=180s
done
kubectl label namespace hangar pod-security.kubernetes.io/enforce=restricted --overwrite
echo "[lab] Ready."

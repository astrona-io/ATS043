#!/usr/bin/env bash
# Starting state. Environment only: it creates objects and faults, never the learner's answer.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n fleet rollout status deployment/shuttle --timeout=180s
kubectl -n fleet rollout status deployment/drifter --timeout=180s
mk_csr() { # name common-name organization
  local dir; dir="$(mktemp -d)"
  openssl genrsa -out "$dir/key.pem" 2048 2>/dev/null
  openssl req -new -key "$dir/key.pem" -subj "/CN=$2/O=$3" -out "$dir/req.pem"
  cat <<YAML | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $1
spec:
  request: $(base64 < "$dir/req.pem" | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400
  usages:
    - client auth
YAML
  rm -rf "$dir"
}
mk_csr rowan-csr rowan cadets
mk_csr intruder-csr intruder system:masters
echo "[lab] Ready."

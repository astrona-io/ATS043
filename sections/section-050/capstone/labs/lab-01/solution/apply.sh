#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl -n depot patch secret api-token --type=merge -p '{"stringData":{"token":"token-2"}}'
kubectl -n depot patch secret probe-key --type=merge -p '{"stringData":{"key":"key-2"}}'
kubectl -n depot patch deployment shuttle --type=json -p '[
 {"op":"remove","path":"/spec/template/spec/containers/0/env"},
 {"op":"add","path":"/spec/template/spec/volumes","value":[{"name":"tok","secret":{"secretName":"api-token"}}]},
 {"op":"add","path":"/spec/template/spec/containers/0/volumeMounts","value":[{"name":"tok","mountPath":"/etc/shuttle","readOnly":true}]}]'
kubectl -n depot patch deployment probe --type=json -p '[
 {"op":"replace","path":"/spec/template/spec/containers/0/volumeMounts","value":[{"name":"key","mountPath":"/etc/probe/key","readOnly":true}]}]'
kubectl -n depot rollout status deployment/shuttle --timeout=180s
kubectl -n depot rollout status deployment/probe --timeout=180s
kubectl -n depot patch secret api-token --type=merge -p '{"immutable":true}'
kubectl -n depot patch secret probe-key --type=merge -p '{"immutable":true}'
kubectl -n depot delete secret old-api-token spare-ssh-key
echo "[solution] Applied."

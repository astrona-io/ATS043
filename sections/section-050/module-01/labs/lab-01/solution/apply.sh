#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl -n vault patch secret db-password --type=merge -p '{"stringData":{"password":"new-value"}}'
kubectl -n vault patch secret db-password --type=merge -p '{"immutable":true}'
kubectl -n vault patch deployment scout --type=json -p '[
 {"op":"remove","path":"/spec/template/spec/containers/0/env"},
 {"op":"add","path":"/spec/template/spec/volumes","value":[{"name":"db","secret":{"secretName":"db-password"}}]},
 {"op":"add","path":"/spec/template/spec/containers/0/volumeMounts","value":[{"name":"db","mountPath":"/etc/scout","readOnly":true}]}]'
kubectl -n vault rollout status deployment/scout --timeout=180s
echo "[solution] Applied."

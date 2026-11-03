#!/usr/bin/env bash
# Check: A ConfigMap create is recorded at Request level with the request body and no response body
set -uo pipefail
fail=0

READER="audit-grader-reader-$$"
START_TIME="$(date -u +%Y-%m-%dT%H:%M:%S)"

cleanup() {
  kubectl -n kube-system delete pod "$READER" --ignore-not-found --wait=false >/dev/null 2>&1
}
trap cleanup EXIT

# start_reader: runs a short-lived pod on the control plane node that mounts
# the node directory /var/log/kubernetes/audit read-only. It lets the grader
# read the audit log with kubectl alone, without access to the node shell.
start_reader() {
  kubectl -n kube-system delete pod "$READER" --ignore-not-found --wait=true >/dev/null 2>&1
  kubectl apply -f - >/dev/null <<YAML || return 1
apiVersion: v1
kind: Pod
metadata:
  name: $READER
  namespace: kube-system
spec:
  nodeSelector:
    node-role.kubernetes.io/control-plane: ""
  tolerations:
    - operator: Exists
  restartPolicy: Never
  terminationGracePeriodSeconds: 0
  containers:
    - name: reader
      image: curlimages/curl:8.22.0
      imagePullPolicy: IfNotPresent
      securityContext:
        runAsUser: 0
      command: ["sh", "-c", "sleep 600"]
      volumeMounts:
        - name: audit
          mountPath: /audit
          readOnly: true
  volumes:
    - name: audit
      hostPath:
        path: /var/log/kubernetes/audit
        type: DirectoryOrCreate
YAML
  kubectl -n kube-system wait --for=condition=Ready "pod/$READER" --timeout=120s >/dev/null 2>&1
}

# read_audit_log: prints the whole audit log, one JSON event per line.
read_audit_log() {
  kubectl -n kube-system exec "$READER" -- cat /audit/audit.log 2>/dev/null
}

if ! start_reader; then
  echo "FAIL: the grader could not read the control plane node (is the API server ready?)"
  exit 1
fi

NAME="audit-grader-cm-$(date +%s)"
kubectl -n starfleet create configmap "$NAME" --from-literal=k=v >/dev/null 2>&1 || { echo "FAIL: the grader could not create a ConfigMap in starfleet"; exit 1; }
event=""
for _ in $(seq 1 10); do
  event="$(read_audit_log | jq -c --arg since "$START_TIME" --arg name "$NAME" 'select(.stage == "ResponseComplete" and .verb == "create" and .objectRef.resource == "configmaps" and .objectRef.name == $name and .stageTimestamp >= $since)' 2>/dev/null | tail -1)"
  [ -n "$event" ] && break
  sleep 3
done
kubectl -n starfleet delete configmap "$NAME" --wait=false >/dev/null 2>&1
if [ -z "$event" ]; then echo "FAIL: no audit event for the ConfigMap create was written"; exit 1; fi
level="$(printf "%s" "$event" | jq -r '.level')"
[ "$level" = "Request" ] || { echo "FAIL: the ConfigMap create was recorded at level $level, expected Request"; fail=1; }
[ "$(printf "%s" "$event" | jq -r 'has("requestObject")')" = "true" ] || { echo "FAIL: the event has no requestObject"; fail=1; }
[ "$(printf "%s" "$event" | jq -r 'has("responseObject")')" = "false" ] || { echo "FAIL: the event holds a responseObject, which Request level does not record"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: A ConfigMap create is recorded at Request level with the request body and no response body"; fi
exit "$fail"

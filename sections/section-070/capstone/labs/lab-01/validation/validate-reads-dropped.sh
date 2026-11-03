#!/usr/bin/env bash
# Check: Routine reads of Pods and ConfigMaps are not recorded while changes still are
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

MARK="audit-grader-marker-$(date +%s)"
kubectl -n starfleet create configmap "$MARK" --from-literal=k=v >/dev/null 2>&1 || { echo "FAIL: the grader could not create a ConfigMap in starfleet"; exit 1; }
kubectl -n starfleet get pods >/dev/null 2>&1
kubectl -n starfleet get configmaps >/dev/null 2>&1
kubectl -n starfleet get configmap "$MARK" >/dev/null 2>&1
sleep 10
recent="$(read_audit_log | jq -c --arg since "$START_TIME" 'select(.stageTimestamp >= $since)' 2>/dev/null)"
kubectl -n starfleet delete configmap "$MARK" --wait=false >/dev/null 2>&1
marker="$(printf "%s\n" "$recent" | jq -r --arg n "$MARK" 'select(.verb == "create" and .objectRef.name == $n) | .auditID' 2>/dev/null | head -1)"
if [ -z "$marker" ]; then echo "FAIL: the ConfigMap create was not recorded, so the log cannot be judged"; exit 1; fi
reads="$(printf "%s\n" "$recent" | jq -r 'select(.user.username == "kubernetes-admin" and (.verb == "get" or .verb == "list") and .objectRef.namespace == "starfleet" and (.objectRef.resource == "pods" or .objectRef.resource == "configmaps")) | .auditID' 2>/dev/null | wc -l | tr -d ' ')"
if [ "$reads" -gt 0 ]; then echo "FAIL: $reads get or list requests for pods and configmaps were recorded. Drop reads with a level None rule placed after the sensitive rules."; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Routine reads of Pods and ConfigMaps are not recorded while changes still are"; fi
exit "$fail"

#!/usr/bin/env bash
# Check: The log is rotated with maxsize, maxage and maxbackup so it cannot fill the disk or grow without limit
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

NODE="$(kubectl get nodes -l node-role.kubernetes.io/control-plane -o jsonpath='{.items[0].metadata.name}')"
command_line="$(kubectl -n kube-system get pod "kube-apiserver-${NODE}" -o jsonpath='{.spec.containers[0].command}' 2>/dev/null)"
for flag in audit-log-maxsize audit-log-maxage audit-log-maxbackup; do
  if ! printf "%s" "$command_line" | grep -q -- "--${flag}=[1-9]"; then echo "FAIL: the kube-apiserver has no --${flag} flag with a value above 0"; fail=1; fi
done

if [ "$fail" -eq 0 ]; then echo "PASS: The log is rotated with maxsize, maxage and maxbackup so it cannot fill the disk or grow without limit"; fi
exit "$fail"

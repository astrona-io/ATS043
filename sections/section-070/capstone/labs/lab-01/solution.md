# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-070/capstone/labs/lab-01
```

## Step 1: Write the policy

Save this as `audit-policy.yaml`:

```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages:
  - RequestReceived
rules:
  - level: None
    nonResourceURLs: ["/healthz*", "/livez*", "/readyz*", "/version"]
  - level: Metadata
    resources:
      - group: ""
        resources: ["secrets"]
  - level: Request
    resources:
      - group: ""
        resources: ["configmaps"]
    verbs: ["create", "update", "patch", "delete"]
  - level: None
    verbs: ["get", "list", "watch"]
  - level: Metadata
```

The Secret rule comes first among the resource rules, so Secret reads stay at `Metadata` and are not caught by the rule that drops reads. The ConfigMap rule lists only write verbs, so ConfigMap reads fall through to the rule that drops them.

## Step 2: Put the policy on the node and enable the flags

```sh
CP=$(kubectl get nodes -l node-role.kubernetes.io/control-plane -o jsonpath='{.items[0].metadata.name}')
podman exec "$CP" mkdir -p /etc/kubernetes/audit /var/log/kubernetes/audit
podman cp audit-policy.yaml "$CP":/etc/kubernetes/audit/audit-policy.yaml
podman exec "$CP" cp /etc/kubernetes/manifests/kube-apiserver.yaml /etc/kubernetes/kube-apiserver.before-audit.yaml
podman exec "$CP" cp /etc/kubernetes/manifests/kube-apiserver.yaml /tmp/kube-apiserver.yaml
podman exec "$CP" sed -i \
  -e '/^    - kube-apiserver$/a\    - --audit-policy-file=/etc/kubernetes/audit/audit-policy.yaml\n    - --audit-log-path=/var/log/kubernetes/audit/audit.log\n    - --audit-log-maxage=1\n    - --audit-log-maxbackup=1\n    - --audit-log-maxsize=10' \
  -e '/^    volumeMounts:$/a\    - mountPath: /etc/kubernetes/audit\n      name: audit-policy\n      readOnly: true\n    - mountPath: /var/log/kubernetes/audit\n      name: audit-log' \
  -e '/^  volumes:$/a\  - hostPath:\n      path: /etc/kubernetes/audit\n      type: Directory\n    name: audit-policy\n  - hostPath:\n      path: /var/log/kubernetes/audit\n      type: DirectoryOrCreate\n    name: audit-log' \
  /tmp/kube-apiserver.yaml
podman exec "$CP" mv /tmp/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml
until kubectl --request-timeout=5s get --raw=/readyz >/dev/null 2>&1; do sleep 5; done
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-070/capstone/labs/lab-01
```

Docker users replace `podman` with `docker`. If the API server does not answer after two minutes, restore `/etc/kubernetes/kube-apiserver.before-audit.yaml` over the manifest and repeat the edit.

## Step 3: Check the events yourself

```sh
kubectl -n starfleet create configmap check --from-literal=k=v
kubectl -n starfleet get pods
podman exec "$CP" cat /var/log/kubernetes/audit/audit.log | jq -c 'select(.objectRef.name == "check") | {verb, level, request: has("requestObject"), response: has("responseObject")}'
```

The create is recorded at `Request` with a request body and no response body, and the `get pods` call writes no event. Destroy the lab when you are done:

```sh
kubectl -n starfleet delete configmap check
astrona destroy ats-043-capstone-070
```

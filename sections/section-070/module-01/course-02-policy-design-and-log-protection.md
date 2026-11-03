# Policy Design And Log Protection

A policy that records everything fills the disk and hides the events that matter. A policy that records too little leaves an incident unexplained. A log that records secret values becomes a second place to steal them. This part shows how to choose levels for sensitive resources, how rule order and noise filters shape the result, and how to protect the log after it is written.

## Secrets and request bodies

A `Request` or `RequestResponse` event for a Secret writes the Secret's `data` field into the log. The values are base64 text, which anyone can decode. The same is true for a `get` of a Secret at `RequestResponse`, because the response body holds the value. Anyone who can read the audit log then reads every Secret that was touched, and the log is often readable by more people and systems than the Secrets are.

A `Metadata` rule for Secrets keeps the facts and drops the values. The event still shows who read or changed `scout-db-credentials`, when and with what result:

```yaml
- level: Metadata
  resources:
    - group: ""
      resources: ["secrets"]
```

ConfigMaps and custom resources that carry tokens or credentials need the same treatment. A `patch` body is a list of patch operations, not an object, and it can also carry a secret value. A rule that sets a high level for a whole API group records every secret in that group.

## Rule order decides the result

The first matching rule wins, so a broad rule placed early removes the effect of every rule after it. In this policy the Secret rule is never reached:

```yaml
rules:
  - level: RequestResponse
  - level: Metadata
    resources:
      - group: ""
        resources: ["secrets"]
```

The first rule has no match fields, so it matches every request. Every Secret event is written at `RequestResponse` with its bodies, and the Secret rule below it applies to nothing. Swapping the two rules gives the intended result. Read a policy from the top and for each rule ask which requests it takes away from the rules below it.

Check the effect on the running cluster instead of trusting the file. Create a Secret and read the event for it:

<!-- astrona:playground:renew -->

```sh
CP=astro-ats-043-playground-070-01-control-plane
kubectl -n starfleet create secret generic hatch-code --from-literal=code=open-sesame-not-real
podman exec "$CP" cat /var/log/kubernetes/audit/audit.log \
  | jq -c 'select(.objectRef.name == "hatch-code" and .stage == "ResponseComplete") | {verb, level, user: .user.username, requestObject: has("requestObject"), responseObject: has("responseObject")}'
```

With the policy from the previous part, the event has `level: Metadata` and both body checks are `false`. Delete the Secret with `kubectl -n starfleet delete secret hatch-code`.

## Cut noise without losing evidence

Most events come from the cluster itself. The kubelet, the scheduler and the controllers read and watch objects all the time, and the kubelet calls health endpoints every few seconds. Rules with `users`, `userGroups`, `verbs` and `nonResourceURLs` remove them:

```yaml
- level: None
  userGroups: ["system:nodes"]
  verbs: ["get", "list", "watch"]
- level: None
  users: ["system:kube-scheduler", "system:kube-controller-manager"]
  verbs: ["get", "list", "watch"]
- level: None
  nonResourceURLs: ["/healthz*", "/livez*", "/readyz*", "/version"]
```

Only drop what you can name. A rule `level: None` for all `get`, `list` and `watch` requests also drops the reads of a person who browses Secrets, unless a rule above it records Secrets. Put the sensitive reads first and the broad noise filters after them. The field `omitStages: ["RequestReceived"]` halves the number of events for most requests, because only the completed event carries the response status.

## Where the log goes

The API server has two backends. The log backend writes JSON lines to a file given by `--audit-log-path`. It rotates the file with three flags:

- `--audit-log-maxsize`: the size in megabytes at which the file is rotated.
- `--audit-log-maxage`: the number of days to keep rotated files.
- `--audit-log-maxbackup`: the number of rotated files to keep.

When none of the retention flags is set, old files are not removed by age or count, and the volume can fill. When they are set too low, the oldest events are deleted before anyone looks. Set the retention to cover the time between an event and its discovery, not the time of a short test.

The webhook backend sends events to an HTTP endpoint. The flag `--audit-webhook-config-file` names a kubeconfig-style file that holds the address and credentials. The flags `--audit-log-mode` and `--audit-webhook-mode` choose how events are written: `batch` buffers them and writes them in the background, `blocking` makes the API server wait for the backend for every event, and `blocking-strict` also fails the request when the write at the first stage fails. Batch can drop events when the buffer is full. Blocking slows the API server when the backend is slow. Pick the mode that matches whether lost evidence or lost availability costs more.

## Protect the log

The audit log is the record that an attacker with API access wants to change. Four weaknesses follow from the design:

- The file sits on the control plane node. Anyone with access to that node, or a Pod that mounts the directory with a `hostPath` volume, can read it and, with write access, change it.
- A caller with enough permissions can edit the manifest of the API server and remove the audit flags. The events before the change stay in the file. Events after it do not exist.
- A local file is lost with the node. A webhook endpoint that an administrator controls can be changed by the same administrator.
- Events from different machines are ordered by their clocks. A node with a wrong clock produces a timeline that does not match the others.

The controls are matching:

- Ship events to a store that control plane administrators cannot change, and alert when events stop arriving.
- Restrict `hostPath` volumes and node shell access, so that the directory is not reachable from workloads.
- Alert on any change to the API server manifest and on the API server restarting.
- Keep node clocks synchronized.

Try the first weakness yourself. Start a Pod that mounts the node's log directory and read the file from it:

```sh
kubectl -n outpost run logreader --image=curlimages/curl:8.22.0 --overrides='{"spec":{"nodeSelector":{"node-role.kubernetes.io/control-plane":""},"tolerations":[{"operator":"Exists"}],"volumes":[{"name":"a","hostPath":{"path":"/var/log/kubernetes/audit"}}],"containers":[{"name":"logreader","image":"curlimages/curl:8.22.0","command":["sleep","300"],"volumeMounts":[{"name":"a","mountPath":"/audit","readOnly":true}]}]}}'
kubectl -n outpost wait --for=condition=Ready pod/logreader --timeout=60s
kubectl -n outpost exec logreader -- sh -c 'tail -n 1 /audit/audit.log'
kubectl -n outpost delete pod logreader
```

The last event of the log prints from inside the Pod. The Pod was allowed because the playground has no admission policy against `hostPath`. In a cluster where Pod Security blocks it, the same request is refused and the log directory is not reachable this way.

## What the log cannot tell you

The log shows requests to the API. It does not show a command run with `kubectl exec` after the session opens, only that the `exec` request was made against the `pods/exec` subresource. It does not show files read inside a container, network traffic or a process started by an application. Combine the audit log with runtime and application evidence to learn what happened after a request succeeded.

## Common pitfalls

> [!WARNING]
> - Recording Secrets at `Request` or `RequestResponse`. The log then holds the secret values in base64.
> - Putting a `level: None` read filter before the rule that records Secret reads.
> - Keeping the only copy of the log on the control plane node.
> - Setting log rotation so low that the oldest events are deleted before they are reviewed.
> - Treating a missing event as proof that nothing happened. A policy gap or a collection failure looks the same.

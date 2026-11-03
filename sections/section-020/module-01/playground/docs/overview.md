# Overview: Pod Security Admission Decisions (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Label namespaces, break pods, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespace `starfleet` with `scout`, `probe` and `shuttle`, and the namespace `outpost` with `drifter`.
- No Pod Security labels on any namespace. Without labels and without an admission configuration, the default level is `privileged`.

## Helpers

Paste these once in each terminal. `try_level` runs a server-side dry run that shows which existing pods would break a level. `show_labels` prints the Pod Security labels of a namespace.

```sh
try_level() {
  kubectl label --dry-run=server --overwrite namespace "$1" "pod-security.kubernetes.io/enforce=$2"
}
show_labels() {
  kubectl get namespace "$1" -o json | jq '.metadata.labels | with_entries(select(.key | startswith("pod-security")))'
}
```

Use them like this: `try_level starfleet restricted`, `show_labels starfleet`.

## Practice tasks

- Label a new namespace with `enforce: baseline` and `warn: restricted`. Create a plain pod and read the warning. Create a privileged pod and read the refusal.
- Create a Deployment with a privileged template in an `enforce: baseline` namespace. Find the failure in the ReplicaSet events, not in the Deployment.
- Label a namespace with `enforce` spelled wrongly (`enforc`). Check that a privileged pod is still accepted.
- Pin `enforce-version` to `v1.35` and to `latest` and compare the labels.
- Run `try_level` with `restricted` for `starfleet` and list which pods it names.

# Overview: Pod Security Profiles (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Apply pods, break them, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` points at it as the cluster administrator.
- The namespace `starfleet` with the Deployments `scout` (podinfo), `probe` (go-httpbin) and `shuttle` (curl), each on its own ServiceAccount.
- The namespace `outpost` with the Deployment `drifter`.
- None of the workloads sets a `securityContext`. No namespace has a Pod Security label.

## Helper

Paste this once in each terminal. It prints the Pod Security level that a server-side dry run would apply to every namespace, without changing anything:

```sh
check_level() {
  kubectl label --dry-run=server --overwrite namespace --all "pod-security.kubernetes.io/enforce=$1"
}
```

Use it like this: `check_level baseline`, then `check_level restricted`. Warnings name the pods that would break the level.

## Practice tasks

- Run `check_level baseline`, then `check_level restricted`. Compare which of the Starfleet pods each level names.
- Create a namespace labelled `pod-security.kubernetes.io/enforce: restricted` and try to create a pod with no security context. Read each violated control in the error.
- Write a pod with `privileged: true` and one with `hostPath`. Find which level each breaks first.
- Add `runAsNonRoot: true` without `runAsUser` to a podinfo pod and read the container error. Then add a numeric `runAsUser`.
- Add `capabilities.add: ["NET_BIND_SERVICE"]` after `drop: ["ALL"]` and confirm Restricted still accepts the pod. Try `SYS_TIME` and read the result.

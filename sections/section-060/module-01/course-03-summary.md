# Summary

A namespace scopes names, permissions, quotas and policies. It does not separate the kernel, the nodes, the container runtime or, by default, the network. A Pod in one namespace can reach a Service in another by its DNS name. A ResourceQuota limits the total objects and compute that a namespace may use, and a LimitRange injects default requests and limits so that Pods without values are still admitted. Quotas check new objects only and do not remove running ones. A memory limit makes the kernel kill the offending container instead of an unrelated process.

Containers share the node's kernel. The fields `hostPID`, `hostNetwork`, `hostIPC`, `hostPath` and `privileged` each remove a boundary. Taints and node selectors place a tenant on dedicated nodes, and a toleration only allows it. A RuntimeClass selects a sandbox runtime such as gVisor or Kata, which adds a user-space or guest kernel, and the node must provide the handler. A RoleBinding with a ServiceAccount from another namespace is a deliberate path between namespaces.

- Name the boundary and what stays shared across it.
- Pair a quota with a LimitRange.
- Dedicated nodes need both a taint and a selector.
- Sandbox runtimes reduce kernel exposure, not network or API exposure.

<!-- astrona:playground:destroy -->

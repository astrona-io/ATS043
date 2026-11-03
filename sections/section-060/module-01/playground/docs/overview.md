# Overview: Isolation And Segmentation (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`. `scout` and `probe` have Services.
- Only one node exists, so taints affect every new Pod.

## Practice tasks

- Call `scout` from `drifter` in the other namespace with `curl` and the full DNS name.
- Create a namespace with a ResourceQuota on `requests.cpu` and start a Pod without requests. Read the error. Add a LimitRange and try again.
- Lower a quota below current usage and show that running Pods are not removed.
- Label and taint the node, start Pods with and without a toleration and read their state. Remove the taint when you finish.
- Create a RuntimeClass with the handler `runsc` and start a Pod that uses it. Read the event.
- Create a Pod with `hostPID: true` and run `ps` inside it to see node processes.
- List RoleBindings that name a ServiceAccount from another namespace.

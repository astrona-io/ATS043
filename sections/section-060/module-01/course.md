# Isolation And Segmentation Across Trust Boundaries

Kubernetes runs many workloads on shared machines. A namespace gives them separate names and policy scopes, but it does not separate their kernel, their nodes or their network. This module shows what a namespace does and does not isolate, how quotas and limits stop one tenant from consuming a shared resource, and what is shared between Pods on the same node.

The module explains each boundary by what it separates and what stays shared. It does not rate a design as isolated or not. It asks which identity, kernel, network path and administrator can cross each boundary.

The module has two parts. **Namespaces And Resource Isolation** covers namespace scope, ResourceQuota, LimitRange and what one workload can take from its neighbors. **Node And Runtime Isolation** covers the shared kernel, host namespaces and host paths, dedicated nodes with taints, RuntimeClass and cross-namespace access.

## Learning objectives

After this module you can:

- State what a namespace separates and what it leaves shared.
- Configure a ResourceQuota and a LimitRange and predict their effect.
- Explain what Pods on one node share.
- Choose a stronger boundary such as dedicated nodes or a sandbox runtime and name what it still shares.

## Your playground

The playground is a single-node `kind` cluster running Kubernetes 1.35. It has the namespace `starfleet` with `scout`, `probe` and `shuttle`, and the namespace `outpost` with `drifter`. You run every command as the cluster administrator.

Launch the playground now and keep it running while you read:

<!-- astrona:playground -->

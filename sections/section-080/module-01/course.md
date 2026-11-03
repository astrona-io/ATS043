# Traffic Isolation With NetworkPolicy

By default every Pod in a cluster can reach every other Pod and Service, in any namespace. A NetworkPolicy changes that for the Pods it selects. This module shows how a policy selects Pods, how isolation starts and what the allow rules mean, and then how egress rules, DNS and cross-namespace selectors change the result.

The module treats a policy as a set of allowed connections. It does not describe traffic as trusted or untrusted. For each connection it asks which Pod starts it, which Pod receives it, which policies select each end and which rules allow it.

The module has two parts. **How NetworkPolicy Selects And Allows Traffic** covers the open default, isolation, default deny, ingress rules, peers and ports. **Egress, DNS And Cross-Namespace Rules** covers egress isolation, the DNS rule it needs, namespace selectors combined with Pod selectors, and what a NetworkPolicy does not control.

## Learning objectives

After this module you can:

- Predict whether a connection is allowed from the policies that select both Pods.
- Write a default deny policy and add rules that allow only the intended callers.
- Combine a namespace selector and a Pod selector in one peer and explain how that differs from two peers.
- Allow DNS when egress is isolated.

## Your playground

The playground is a single-node `kind` cluster running Kubernetes 1.35. Its default network plugin, kindnet, enforces NetworkPolicy. It has the namespace `starfleet` with `scout`, `probe` and `shuttle`, and the namespace `outpost` with `drifter`. No NetworkPolicy exists at the start, so every request succeeds. You run every command as the cluster administrator.

Launch the playground now and keep it running while you read:

<!-- astrona:playground -->

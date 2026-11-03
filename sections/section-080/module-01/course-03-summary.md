# Summary

By default every Pod reaches every other Pod, in any namespace. A NetworkPolicy selects Pods and lists the connections allowed to or from them. A Pod becomes isolated for a direction when a policy selects it and lists that direction in `policyTypes`. Rules only add allowed connections, so two policies on the same Pod allow what either one allows. A policy with an empty `podSelector` and no rules is a default deny. A blocked packet is dropped without an answer, so the caller waits for its timeout.

A connection needs permission at both ends: an egress rule at the source if the source is isolated, and an ingress rule at the destination if the destination is isolated. Rules match the port of the Pod, not of the Service. Isolating egress also blocks DNS, so a rule must allow the cluster DNS Pods on port 53 over UDP and TCP. One entry that combines a namespace selector and a Pod selector allows only the matching Pods in the matching namespaces. Two entries allow the union. A NetworkPolicy does not inspect HTTP, does not encrypt and depends on a network plugin that enforces it.

- Predict a connection from the policies at both ends.
- Allow DNS whenever egress is isolated.
- Use the Pod port in rules.
- Read the dashes in a `from` list before trusting it.

<!-- astrona:playground:destroy -->

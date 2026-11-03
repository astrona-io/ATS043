# Pod Security Admission Decisions

Pod Security Admission (PSA) is the built-in part of the API server that applies the Pod Security Standards to every pod request. It decides at the moment a pod is created or updated, and it reads only the pod specification. A namespace label tells it which level to apply and what to do when a pod breaks the level: refuse it, warn the user, or add an audit annotation.

This module shows how those labels work, why a Deployment can be accepted while its pods are refused, and how to introduce a level on a namespace that already runs workloads. It also separates PSA from the controls it is often confused with: RBAC and image verification.

The module has two parts. **Applying Pod Security Requirements At Admission** explains the labels, the three modes, the version labels and what is checked for pods and for workload resources. **Rolling Out A Level Safely** covers warn and audit first, server-side dry runs, exemptions, cluster-wide defaults and what PSA does not do.

## Learning objectives

After this module you can:

- Distinguish the enforce, warn and audit modes.
- Explain namespace labels and version selection.
- Predict how a policy change affects new and existing pods.
- Separate Pod Security Admission from RBAC and image verification.

## Your playground

The playground is a single-node `kind` cluster running Kubernetes 1.35. It has the namespace `starfleet` with the workloads `scout`, `probe` and `shuttle`, and the namespace `outpost` with `drifter`. No namespace has a Pod Security label yet. You run every command as the cluster administrator.

Launch the playground now and keep it running while you read:

<!-- astrona:playground -->

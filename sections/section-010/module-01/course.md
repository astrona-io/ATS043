# Pod Security Profiles

A container is a normal Linux process with extra limits. By default Kubernetes lets that process run as root, keep many Linux capabilities and mount host directories. If an attacker takes over such a container, the attacker may reach the node. The Pod Security Standards (PSS) are three named sets of rules that say which pod settings are acceptable.

In this module you learn what each profile forbids, which pod fields hold those settings, and how to change a real workload until it fits the strictest profile. Every claim is shown on a running cluster, so keep the playground open next to the reading.

The module has two parts. **Security Contexts And Profile Requirements** explains the `securityContext` fields and what the kubelet and the container runtime do with each one. **Profiles And Compliant Workloads** lists the controls of the Privileged, Baseline and Restricted profiles and walks through fixing a workload that breaks them.

## Learning objectives

After this module you can:

- Compare the Privileged, Baseline and Restricted profiles.
- Explain the purpose and limits of each `securityContext` field.
- Relate image users and writable paths to profile compatibility.
- Distinguish a compliant pod configuration from complete application security.

## Your playground

The playground is a single-node `kind` cluster running Kubernetes 1.35. It has the namespace `starfleet` with the workloads `scout`, `probe` and `shuttle`, and the namespace `outpost` with `drifter`. The workloads use default settings, so none of them is hardened yet. You run every command as the cluster administrator.

Launch the playground now and keep it running while you read:

<!-- astrona:playground -->

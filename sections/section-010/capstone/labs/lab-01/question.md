# Question

Solve this question on: `terminal`

This is the capstone for Pod Security Standards: one integrated task, no step-by-step guidance.

A team namespace called `orbit` is being locked down. It runs the Deployments `beacon`, `relay` and `cargo`. They were written without any hardening. The namespace `workshop` runs a Deployment `tools` that needs a privileged container for a legacy reason.

1. Label `orbit` so that pods that break the `restricted` level are rejected (`enforce`), and so that creating or updating a workload that breaks it also shows a warning (`warn`) and an audit annotation (`audit`). Pin the enforce version to Kubernetes `v1.35` with the matching `-version` label.
2. Make the pods of `beacon`, `relay` and `cargo` meet `restricted` and stay `Running`. `relay` adds the capability `SYS_ADMIN` and is privileged; `cargo` shares the host process namespace and mounts a `hostPath` volume. Use a numeric `runAsUser`.
3. Prove the enforcement works: a server-side dry run of a privileged pod in `orbit` must be refused.
4. Leave `workshop` and `tools` as they are. The namespace must not enforce `baseline` or `restricted`.

Do not delete the Deployments and do not change their images. `kubectl` already points at the cluster as the cluster administrator.

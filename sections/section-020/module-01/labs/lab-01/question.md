# Question

Solve this question on: `terminal`

The namespace `dock` has no Pod Security labels yet. It runs two Deployments: `tug`, whose container is privileged, and `crane`, an ordinary workload. The namespace `yard` runs a legacy Deployment `forklift` that needs its privileged container and must not change.

1. Label `dock` so that pods breaking the `baseline` level are refused (`enforce`), pinned to Kubernetes `v1.35` with `enforce-version`. Also make `warn` and `audit` report violations of the `restricted` level.
2. `tug` breaks `baseline`. Change it so its pods meet `baseline` and stay `Running`. Remove only what is needed; do not delete the Deployment.
3. Prove the result with a server-side dry run: a privileged pod must be refused in `dock`, and a plain pod with no security settings must still be accepted.
4. Do not label or change `yard`.

Do not use `restricted` for `enforce`: `crane` and other plain pods must still be admitted. `kubectl` already points at the cluster as the cluster administrator.

# Question

Solve this question on: `terminal`

Three namespaces need different Pod Security Admission settings. `kubectl` points at the cluster as the cluster administrator.

1. `alpha` was labelled by someone who misspelled a key. Remove the misspelled label. Then make `alpha` enforce `restricted`, pinned to `v1.35` with `enforce-version`. Its Deployment `web` must meet `restricted` and stay `Running`.
2. `beta` must enforce `baseline` and also warn and audit on `restricted`. Its Deployment `batch` runs a privileged container. Make `batch` meet `baseline` and stay `Running`.
3. `gamma` runs a legacy Deployment `agent` that needs `privileged: true` and `hostNetwork: true`. It must not change and must not be blocked. Set `warn` and `audit` to `baseline` on `gamma` so violations are reported, and set no `enforce` label.
4. A privileged pod and a `hostNetwork` pod must be refused by server-side dry run where a level is enforced, and a privileged pod must still be accepted in `gamma`.

Do not delete any Deployment or namespace.

# Question

Solve this question on: `terminal`

The namespace `hangar` enforces the Pod Security `restricted` level with the label `pod-security.kubernetes.io/enforce=restricted`. Three Deployments were started before the label was set: `fuel`, `cargo` and `relay`. Their current pods keep running, but none of them meets `restricted`, so a replacement pod would be rejected.

1. `fuel` runs podinfo with no security settings. Make its pods meet `restricted`.
2. `cargo` mounts a `hostPath` volume. Remove it and make its pods meet `restricted`.
3. `relay` runs a privileged container. Make its pods meet `restricted`.

Use a numeric user ID for `runAsUser`, because the images use text user names. Do not weaken the namespace label, do not delete the Deployments and do not change their images. When you finish, every pod of the three Deployments must be `Running` and meet `restricted`.

`kubectl` already points at the cluster as the cluster administrator.

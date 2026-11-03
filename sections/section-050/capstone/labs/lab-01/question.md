# Question

Solve this question on: `terminal`

The namespace `depot` has two Deployments and four Secrets. `shuttle` takes the Secret `api-token` through an environment variable. `probe` mounts the Secret `probe-key` with `subPath`, so it never sees a refresh. Two other Secrets, `old-api-token` and `spare-ssh-key`, look unused. `kubectl` points at the cluster as the cluster administrator.

1. Rotate `api-token` so its `token` is `token-2`. Deliver it to `shuttle` as a file in a read-only Secret volume at `/etc/shuttle`, without `subPath`. Remove the environment variable. The file is `/etc/shuttle/token`.
2. Rotate `probe-key` so its `key` is `key-2`. Change `probe` so it mounts the Secret as a directory at `/etc/probe/key` without `subPath`. The file is `/etc/probe/key/key`.
3. When both values are final, mark `api-token` and `probe-key` immutable.
4. Prove which Secrets no Pod references and delete only those.
5. Both Deployments must be available at the end.

# Question

Solve this question on: `terminal`

The Deployment `scout` in the namespace `vault` reads the password from the Secret `db-password` through the environment variable `DB_PASSWORD`. The password was exposed and must be rotated to `new-value`. `kubectl` points at the cluster as the cluster administrator.

1. Change the password stored in `db-password` to `new-value`.
2. Change `scout` to receive the password as a file named `password` in a Secret volume mounted read-only at `/etc/scout`, with no `subPath`. Remove the environment variable. The running pod must read `new-value` from the file.
3. After the value and the Deployment are final, mark `db-password` as immutable.
4. Keep the Deployment `scout` available.

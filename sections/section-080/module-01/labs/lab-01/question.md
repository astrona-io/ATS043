# Question

Solve this question on: `terminal`

The namespace `harbor` holds the Deployments `scout`, `shuttle` and `probe`. The Service `scout` forwards port 80 to the Pod port 9898. The namespace `outpost` holds `drifter`. No NetworkPolicy exists, so every Pod can call `scout`. The cluster network plugin enforces NetworkPolicy. `kubectl` points at the cluster as the cluster administrator.

1. Make `scout` accept connections only from `shuttle`, using NetworkPolicy objects in `harbor`.
2. `shuttle` must still reach `scout` through the Service name `scout.harbor.svc`.
3. `probe` in `harbor` and `drifter` in `outpost` must no longer reach `scout`.
4. Leave the Deployments as they are.

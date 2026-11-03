# Question

Solve this question on: `terminal`

The namespace `fleet` holds `scout` (Pod port 9898, Service `scout` on port 80), `probe` (Pod port 8080, Service `probe` on port 80), `shuttle` and `crane`. The namespace `outpost` holds `drifter`, `intruder` and `beacon`. `beacon` has a Service `beacon` on port 80 and Pod port 9898. No NetworkPolicy exists. The network plugin enforces NetworkPolicy. `kubectl` points at the cluster as the cluster administrator. You may only create NetworkPolicy objects in `fleet`.

1. Deny all ingress and all egress for every Pod in `fleet`.
2. Allow every Pod in `fleet` to look up names through the cluster DNS Pods in `kube-system`, on port 53 over both UDP and TCP.
3. `shuttle` must reach `scout` through `http://scout.fleet.svc`. Allow only that.
4. `probe` must accept connections only from the Pod `drifter` in the namespace `outpost`, on its Pod port. `intruder` in `outpost` must not reach it.
5. `crane` must not be able to reach `beacon` in `outpost`.
6. Leave all Deployments and Services as they are.

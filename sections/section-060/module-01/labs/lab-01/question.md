# Question

Solve this question on: `terminal`

The namespace `bay` has no limits. Two Deployments run in it: `drifter`, and `crane`, which shares the node's process namespace. `kubectl` points at the cluster as the cluster administrator.

1. Create a ResourceQuota `bay-quota` in `bay` with these hard limits: `pods` 6, `requests.cpu` 1, `requests.memory` 1Gi and `limits.memory` 2Gi.
2. Create a LimitRange `bay-limits` in `bay` for containers with default requests of 50m CPU and 32Mi memory and a default memory limit of 128Mi. A Pod that states no resources must be admitted with those values.
3. A Pod that requests 4 CPUs must be refused in `bay`.
4. Remove the setting that lets `crane` see the processes of the node. `crane` must be available afterwards.
5. Leave `drifter` as it is.

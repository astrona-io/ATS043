# Question

Solve this question on: `terminal`

Two tenants share one cluster: namespaces `tenant-a` and `tenant-b`. `kubectl` points at the cluster as the cluster administrator. Neither namespace has any limits, one tenant can reach into the other and one workload shares the node.

1. In each namespace create a ResourceQuota named `tenant-quota`:
   - `tenant-a`: `pods` 5, `requests.cpu` 500m, `requests.memory` 512Mi, `limits.memory` 1Gi.
   - `tenant-b`: `pods` 3, `requests.cpu` 250m, `requests.memory` 256Mi, `limits.memory` 512Mi.
2. In each namespace create a LimitRange named `tenant-limits` for containers with default requests of 50m CPU and 32Mi memory and a default memory limit of 128Mi.
3. The ServiceAccount `ops-sa` from `tenant-b` has edit rights in `tenant-a`. Remove that access. It must keep its edit rights inside `tenant-b`.
4. The Deployment `probe` in `tenant-b` shares the process namespace of the node and mounts a directory of the node. Remove both. `probe` must be available afterwards.
5. Leave `scout` in `tenant-a` available.

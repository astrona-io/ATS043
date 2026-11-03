# Question

Solve this question on: `terminal`

The API server of this cluster writes no audit log. The namespace `starfleet` holds a Secret `scout-db-credentials` and a Deployment `scout`. `kubectl` points at the cluster as the cluster administrator. You reach the control plane node with `podman exec` (or `docker exec`) on the container whose name ends in `-control-plane`.

1. Enable audit logging on the API server. The log file is `/var/log/kubernetes/audit/audit.log` on the node and the policy file is `/etc/kubernetes/audit/audit-policy.yaml`.
2. Write the policy so that:
   - A read of a Secret is recorded at `Metadata`, with no request or response body.
   - A create or delete of a Deployment is recorded at `RequestResponse`.
   - Health check requests (`/healthz`, `/livez`, `/readyz`) are not recorded.
   - The `RequestReceived` stage is not recorded.
3. The API server must be ready when you finish.

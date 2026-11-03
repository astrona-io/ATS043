# Question

Solve this question on: `terminal`

The API server of this cluster writes no audit log. The namespace `starfleet` holds a Secret `scout-db-credentials` and a Deployment `scout`. `kubectl` points at the cluster as the cluster administrator. You reach the control plane node with `podman exec` (or `docker exec`) on the container whose name ends in `-control-plane`.

Enable audit logging on the API server with the log file `/var/log/kubernetes/audit/audit.log` and the policy file `/etc/kubernetes/audit/audit-policy.yaml`. Write the policy so that:

1. A read of a Secret is recorded at `Metadata`, with no request or response body.
2. A create, update, patch or delete of a ConfigMap is recorded at `Request`, so the request body is kept and the response body is not.
3. Routine `get`, `list` and `watch` requests for other resources are not recorded.
4. Health check requests (`/healthz`, `/livez`, `/readyz`) and the `RequestReceived` stage are not recorded.

Set the rotation flags `--audit-log-maxsize`, `--audit-log-maxage` and `--audit-log-maxbackup` to values above 0, so that the log is rotated and old files are removed. The API server must be ready when you finish.

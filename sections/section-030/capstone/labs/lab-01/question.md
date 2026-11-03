# Question

Solve this question on: `terminal`

The namespace `fleet` runs two Deployments. `shuttle` runs as `shuttle-sa` and never calls the API. `drifter` runs as `drifter-sa` and reads Pods through the API, so it needs its token. Two people have each sent a CertificateSigningRequest: `rowan-csr` and `intruder-csr`. Legacy token Secrets exist for both ServiceAccounts. `kubectl` points at the cluster as the cluster administrator.

1. Read both requests. Approve the one that is a normal cadet request and deny the one that asks for an administrative group.
2. Give the approved user read access to Pods and other namespaced objects in `fleet` with the built-in `view` role. The user must not be able to delete Pods or read Secrets.
3. Stop `shuttle` from receiving a ServiceAccount token. Existing pods must be replaced.
4. `drifter` must keep its token and stay available.
5. Delete every legacy ServiceAccount token Secret in `fleet`.

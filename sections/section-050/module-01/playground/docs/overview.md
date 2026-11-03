# Overview: Secrets And Sensitive Configuration (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`.
- The etcd Pod in `kube-system`, labelled `component=etcd`, with `etcdctl` and the client certificates under `/etc/kubernetes/pki/etcd`.

## Practice tasks

- Create a Secret, decode its value with `base64 -d` and read its record in etcd with `etcdctl get /registry/secrets/<namespace>/<name>`.
- Check the API server flags for `--encryption-provider-config`.
- Mount one Secret as an environment variable and as a volume, change the Secret and compare what the container sees after a minute.
- Mount a Secret with `subPath` and show that the file never changes.
- Mark a Secret `immutable: true` and try to change its data.
- Run `kubectl apply` with a Secret that uses `stringData` and read the last-applied annotation.
- Run `kubectl exec` and print the environment of a container that uses `secretKeyRef`.

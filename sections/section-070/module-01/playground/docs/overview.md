# Overview: Audit Policy And Security Evidence (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`.
- No audit logging. The API server runs without `--audit-policy-file` and `--audit-log-path`.
- The control plane container is `astro-ats-043-playground-070-01-control-plane`. Reach it with `podman exec` or `docker exec`.

## Practice tasks

- Save a policy on the node, add the two audit flags and the two `hostPath` volumes to the API server manifest and wait for the restart.
- Create and delete a Deployment and read both events with `jq`.
- Compare the events for a Secret read at `Metadata` and at `RequestResponse`. Look for the base64 value.
- Move a broad rule above a specific one and see which events change.
- Add the rotation flags `--audit-log-maxsize`, `--audit-log-maxage` and `--audit-log-maxbackup`.
- Start a Pod that mounts the audit directory with a `hostPath` volume and read the log from inside it.
- If the API server does not start, restore the backup copy of the manifest from outside the `manifests` directory.

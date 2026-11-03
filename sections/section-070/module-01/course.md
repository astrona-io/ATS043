# Audit Policy And Security Evidence

The API server decides what happens in a cluster, and by default it keeps no record of who asked. Audit logging records each request with the caller, the action, the target and the result. This module shows how an audit policy chooses what is recorded, how to turn audit logging on for the API server, and how to keep the log useful and out of the wrong hands.

The module treats the log as evidence with a limited reach. It records requests to the Kubernetes API. It does not record commands typed inside a container, files read by an application or traffic between Pods.

The module has two parts. **Audit Events, Stages And Policy Levels** covers the event format, the four stages, the four levels and rule matching, and enables audit logging on the control plane of the playground. **Policy Design And Log Protection** covers Secrets and request bodies, rule order, noise, log rotation and webhook backends, and who can read or change the log.

## Learning objectives

After this module you can:

- Read an audit event and name the caller, verb, target and result.
- Write a policy that uses ordered rules, levels and omitted stages.
- Record Secret access at the `Metadata` level so the log holds no secret values.
- Name the ways an attacker or an error can remove evidence and the controls that reduce them.

## Your playground

The playground is a single-node `kind` cluster running Kubernetes 1.35. It has the namespace `starfleet` with `scout`, `probe` and `shuttle`, and the namespace `outpost` with `drifter`. Audit logging is off at the start. You run every `kubectl` command as the cluster administrator, and you reach the control plane node with `podman exec` (Docker users replace `podman` with `docker`). The control plane container is named `astro-ats-043-playground-070-01-control-plane`.

Launch the playground now and keep it running while you read:

<!-- astrona:playground -->

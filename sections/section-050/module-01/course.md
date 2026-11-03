# Secrets And Sensitive Configuration

A Secret is a Kubernetes object meant for sensitive data such as passwords, tokens and keys. It is stored by the API server, read through the API, and delivered to Pods as environment variables or files. Each of these steps can expose the value. A Secret is not encrypted by default, and base64 is an encoding that anyone can reverse.

This module follows a Secret from creation to the process that uses it. It shows what is stored in etcd, how to turn on encryption at rest, how delivery to a container differs between environment variables and volumes, which paths leak a value, and how to rotate a credential without an outage.

The module has two parts. **Secret Storage And Encryption At Rest** covers Secret types, base64, the etcd record, the encryption configuration and the access paths to a stored value. **Delivery, Rotation And Exposure Paths** covers environment variables against volumes, update behavior, immutable Secrets, rotation and the places a value escapes.

## Learning objectives

After this module you can:

- Explain why base64 is not protection and what encryption at rest changes.
- Describe how a Secret reaches a container as an environment variable or a file.
- Predict what happens to a running Pod when a Secret changes.
- Rotate a credential and find the paths that expose it.

## Your playground

The playground is a single-node `kind` cluster running Kubernetes 1.35. It has the namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`. You run every command as the cluster administrator and can read etcd from the control plane Pod.

Launch the playground now and keep it running while you read:

<!-- astrona:playground -->

# Summary

A Secret is a Kubernetes object for sensitive data, limited to one mebibyte and typed by its expected keys. Its `data` field holds base64, which is a reversible encoding and no protection. By default the API server writes the Secret to etcd as received, so anyone with access to etcd or a backup reads every value. Encryption at rest, configured with an `EncryptionConfiguration` file, encrypts new writes with the first listed provider. Existing Secrets must be rewritten. A KMS provider keeps the key outside the node.

A Pod receives a Secret as an environment variable, which is fixed when the container starts, or as a file in a tmpfs volume, which the kubelet refreshes. A `subPath` mount is never refreshed, and an application that reads once never sees the update. Rotation needs a new credential at the source, a rollout or a reload, a check, and the revocation of the old value. Values escape through `exec`, logs, backups, images, shell history and the last-applied annotation.

- Base64 is not encryption.
- Encryption at rest protects etcd, not authorized API callers.
- Environment variables are fixed at container start.
- Rotation ends with revoking the old credential.

<!-- astrona:playground:destroy -->

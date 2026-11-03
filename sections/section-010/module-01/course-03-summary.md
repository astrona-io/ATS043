# Summary

A security context is a group of settings that the kubelet gives to the container runtime. The runtime applies them to the Linux process: the user and group, the capability set, the system call filter and the flag that blocks privilege gain. A pod that declares nothing runs with the image's defaults, which are often root with many capabilities.

The Pod Security Standards define three profiles. Privileged has no restrictions. Baseline blocks host namespaces, privileged containers, host paths, unsafe capabilities and disabled system call filters. Restricted adds a limited volume list, no privilege escalation, a non-root user, a runtime default system call filter and dropped capabilities.

A profile is checked against the pod specification at admission. A Deployment is accepted even when its template breaks the level, and the pods it creates are rejected. An image with a text user name needs a numeric `runAsUser` before `runAsNonRoot` can pass, and a writable path needs a volume. A compliant pod still needs safe code, narrow API permissions and protected secrets.

- Baseline stops known host takeover paths; Restricted follows hardening practice.
- `runAsNonRoot` is a check; `runAsUser` is the value.
- `drop: ["ALL"]` plus an optional `NET_BIND_SERVICE` is the Restricted capability rule.
- Compliance is a property of the specification, not proof of a safe application.

<!-- astrona:playground:destroy -->

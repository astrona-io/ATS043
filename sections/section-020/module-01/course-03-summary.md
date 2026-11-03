# Summary

Pod Security Admission is a plugin in the API server that applies a Pod Security Standards level to a pod specification. A namespace label chooses the level for each of three modes. The `enforce` mode refuses the pod, the `warn` mode accepts it and sends a warning to the user, and the `audit` mode accepts it and adds an annotation to the audit event. Version labels pin the rules to a Kubernetes minor version.

The plugin runs after authentication and authorization. It checks Pod objects for `enforce` and pod templates of workload resources for `warn` and `audit`. A Deployment with a violating template is therefore accepted, and its pods are refused later by the ReplicaSet controller. A label change never stops a pod that already runs.

A safe rollout sets `warn` and `audit` to the target level, uses a server-side dry run to find violators, fixes the workloads and then raises `enforce`. Exemptions skip the checks completely and are set in the API server configuration. Pod Security Admission does not replace RBAC, image verification or runtime defences.

- Labels use the form `pod-security.kubernetes.io/<mode>` and `<mode>-version`.
- Existing pods keep running after a label change.
- A misspelled label key does nothing.
- Exempting a controller ServiceAccount exempts every user of it.

<!-- astrona:playground:destroy -->

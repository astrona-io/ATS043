# Rolling Out A Level Safely

Switching `enforce` to `restricted` on a namespace with running workloads can leave the next restart of every pod blocked. This part shows a rollout order that finds the problems first, how exemptions and cluster defaults work, and which checks Pod Security Admission does not make.

## Find the violators before you enforce

The `warn` and `audit` modes exist for migration. Set them to the target level first, with `enforce` unchanged. Developers then see warnings when they apply a workload, and the audit log records every violation. When the warnings stop, raise `enforce`.

A server-side dry run tells you what a label change would break without changing anything. The API server evaluates every existing pod in the namespace against the new level and prints a warning for each violator. Save a namespace for the test as `namespace-yard.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: yard
```

Apply it and start one violating pod with the commands in the shell:

<!-- astrona:playground:renew -->

```sh
kubectl apply -f namespace-yard.yaml
kubectl -n yard run legacy --image=mccutchen/go-httpbin:2.25.0 --port=8080
```

Then run the dry run:

```sh
kubectl label --dry-run=server --overwrite namespace yard pod-security.kubernetes.io/enforce=restricted
```

The command prints a warning that names the pod `legacy` and lists each missing Restricted control. The label is not changed. Run it for every namespace with `--all` in place of the name to survey the whole cluster.

## Exemptions

An exemption makes PSA skip a request completely: no enforce, no warn, no audit. Exemptions are configured on the API server, not in a namespace label. Three kinds exist: `usernames` (the authenticated or impersonated user), `runtimeClasses` (the pod's runtime class) and `namespaces`. System namespaces such as `kube-system` are the usual exempt namespaces.

Exempt a user carefully. Most pods are not created by people but by controllers. Exempting a person only skips direct pod creation, and exempting a controller's ServiceAccount, for example the ReplicaSet controller, would exempt everyone who can create a Deployment. Prefer exempting a namespace or a runtime class that you control.

## Cluster-wide defaults

A namespace with no labels gets the defaults from the API server's admission configuration. Without configuration the default level is `privileged` for all modes. The cluster administrator can set stricter defaults in an `AdmissionConfiguration` file passed to the API server with `--admission-control-config-file`. The `PodSecurity` plugin configuration has this form:

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
  - name: PodSecurity
    configuration:
      apiVersion: pod-security.admission.config.k8s.io/v1
      kind: PodSecurityConfiguration
      defaults:
        enforce: "baseline"
        enforce-version: "latest"
        warn: "restricted"
        warn-version: "latest"
        audit: "restricted"
        audit-version: "latest"
      exemptions:
        usernames: []
        runtimeClasses: []
        namespaces: [kube-system]
```

A file on the control plane node changes the API server flags, so on a managed cluster you cannot edit it. Namespace labels override these defaults for their own namespace.

## What PSA does not do

PSA checks the pod specification against a fixed list of controls. It does not check who may create the pod: that is RBAC. It does not check where the image comes from or whether it is signed: that is image verification, done by an admission webhook or policy engine. It does not look at the process after it starts, and it does not change a pod to make it compliant. It also cannot express your own rules, such as requiring a label or a resource limit.

Some updates skip the check even when the pod breaks the level: metadata updates, valid changes to `activeDeadlineSeconds` and valid changes to `tolerations`. These changes cannot give the pod more privilege.

## Reading a warning and fixing it

Each warning line names the violated control in the form the pod specification uses. A line about `allowPrivilegeEscalation` points at the container security context. A line about `runAsNonRoot` or `seccompProfile` points at the pod or container security context too. A line about `hostPath` points at `spec.volumes`. Work through the list once per workload, apply the fix to the Deployment template, and run the dry run again until it prints nothing for that namespace.

Order matters when a namespace holds many workloads. Fix the workloads that restart often first, such as Jobs and autoscaled Deployments, because their new pods are the first to be refused after `enforce` is raised. Long-lived pods that never restart can wait, but they will fail on the next node drain or image update.

Keep the `warn` and `audit` labels after you raise `enforce` to a lower level than the target. They keep reporting what still misses the stricter level, so the next step up is already prepared.

Clean up:

```sh
kubectl delete namespace yard
```

You now have a safe order: dry run, warn and audit, fix, enforce. The summary of what each control covers makes the boundary clear: PSA limits a pod's privileges, and other controls must cover identity and images.

## Common pitfalls

> [!WARNING]
> Do not set `enforce` first on a live namespace. Exempting a controller ServiceAccount exempts every user of that controller. A pinned version does not follow cluster upgrades. PSA cannot replace RBAC, image policy or network rules.

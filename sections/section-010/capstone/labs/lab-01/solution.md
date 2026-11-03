# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-010/capstone/labs/lab-01
```

## Step 1: Label the namespace

```sh
kubectl label namespace orbit pod-security.kubernetes.io/enforce=restricted pod-security.kubernetes.io/enforce-version=v1.35 pod-security.kubernetes.io/warn=restricted pod-security.kubernetes.io/audit=restricted --overwrite
```

Existing pods keep running. Only new pods are checked.

## Step 2: Harden the three Deployments

Each container needs `runAsNonRoot: true`, a numeric `runAsUser` such as 10001, `allowPrivilegeEscalation: false`, `capabilities.drop: ["ALL"]` and `seccompProfile.type: RuntimeDefault`. Edit each Deployment with `kubectl -n orbit edit deployment <name>`:

- `beacon`: add the security context.
- `relay`: replace the privileged context. Remove `privileged` and the `SYS_ADMIN` capability.
- `cargo`: remove `hostPID`, the `hostPath` volume and its volume mount, then add the security context.

Watch each rollout. If a rollout stalls, a replacement pod was rejected; the reason is in the events:

```sh
kubectl -n orbit get events --sort-by=.lastTimestamp
```

## Step 3: Prove enforcement

Save this as `pod-privileged.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: privileged-test
  namespace: orbit
spec:
  containers:
    - name: c
      image: mccutchen/go-httpbin:2.25.0
      securityContext:
        privileged: true
```

Run the server-side dry run. The API server refuses it with a Forbidden error:

```sh
kubectl apply --dry-run=server -f pod-privileged.yaml
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-010/capstone/labs/lab-01
```

Do not touch `workshop`. Destroy the lab when you are done:

```sh
astrona destroy ats-043-capstone-010
```

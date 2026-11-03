# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/capstone/labs/lab-01
```

## Step 1: Read the current labels

```sh
kubectl get namespace alpha beta gamma --show-labels
```

`alpha` carries `pod-security.kubernetes.io/enforc`. The API server accepts any label key, so a typo is stored and has no effect.

## Step 2: Fix alpha

Remove the typo and set the real labels:

```sh
kubectl label namespace alpha pod-security.kubernetes.io/enforc-
kubectl label namespace alpha pod-security.kubernetes.io/enforce=restricted pod-security.kubernetes.io/enforce-version=v1.35 --overwrite
```

Save this as `web-patch.yaml`:

```yaml
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 10001
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: web
          securityContext:
            allowPrivilegeEscalation: false
            capabilities:
              drop: ["ALL"]
```

```sh
kubectl -n alpha patch deployment web --patch-file web-patch.yaml
kubectl -n alpha rollout status deployment/web
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/capstone/labs/lab-01
```

## Step 3: Fix beta

```sh
kubectl label namespace beta pod-security.kubernetes.io/enforce=baseline pod-security.kubernetes.io/warn=restricted pod-security.kubernetes.io/audit=restricted --overwrite
kubectl -n beta patch deployment batch --type=json -p '[{"op":"remove","path":"/spec/template/spec/containers/0/securityContext/privileged"}]'
kubectl -n beta rollout status deployment/batch
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/capstone/labs/lab-01
```

## Step 4: Fix gamma

```sh
kubectl label namespace gamma pod-security.kubernetes.io/warn=baseline pod-security.kubernetes.io/audit=baseline --overwrite
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/capstone/labs/lab-01
```

## Step 5: Prove the decisions

```sh
kubectl -n beta run probe-test --image=mccutchen/go-httpbin:2.25.0 --dry-run=server --overrides='{"spec":{"hostNetwork":true}}'
```

The API server refuses it. The same command in `gamma` is accepted and prints a warning. Destroy the lab when you are done:

```sh
astrona destroy ats-043-capstone-020
```

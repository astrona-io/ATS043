# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running. This lab has not been run yet; the commands are checked statically only.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/module-01/labs/lab-01
```

## Step 1: Test the level before enforcing

A server-side dry run lists the pods that would break the new level and changes nothing:

```sh
kubectl label --dry-run=server --overwrite namespace dock pod-security.kubernetes.io/enforce=baseline
```

The warning names the pod of `tug`. If you enforced now, the next replacement pod of `tug` would be refused. Fix it first.

## Step 2: Remove the privileged flag from tug

```sh
kubectl -n dock patch deployment tug --type=json -p '[{"op":"remove","path":"/spec/template/spec/containers/0/securityContext/privileged"}]'
kubectl -n dock rollout status deployment/tug
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/module-01/labs/lab-01
```

`tug-meets-baseline` passes.

## Step 3: Set the labels

```sh
kubectl label namespace dock pod-security.kubernetes.io/enforce=baseline pod-security.kubernetes.io/enforce-version=v1.35 pod-security.kubernetes.io/warn=restricted pod-security.kubernetes.io/audit=restricted --overwrite
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/module-01/labs/lab-01
```

## Step 4: Prove the decision

Save this as `pod-privileged.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: privileged-test
  namespace: dock
spec:
  containers:
    - name: c
      image: mccutchen/go-httpbin:2.25.0
      securityContext:
        privileged: true
```

```sh
kubectl apply --dry-run=server -f pod-privileged.yaml
```

The API server refuses it with a Forbidden error. Destroy the lab when you are done:

```sh
astrona destroy ats-043-lab-020-01
```

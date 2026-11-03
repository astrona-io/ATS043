# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-060/module-01/labs/lab-01
```

## Step 1: Add the quota and the defaults

Save this as `bay-limits.yaml`:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: bay-quota
  namespace: bay
spec:
  hard:
    pods: "6"
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.memory: 2Gi
---
apiVersion: v1
kind: LimitRange
metadata:
  name: bay-limits
  namespace: bay
spec:
  limits:
    - type: Container
      defaultRequest:
        cpu: 50m
        memory: 32Mi
      default:
        memory: 128Mi
```

```sh
kubectl apply -f bay-limits.yaml
kubectl -n bay describe resourcequota bay-quota
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-060/module-01/labs/lab-01
```

## Step 2: Prove the defaults and the refusal

```sh
kubectl -n bay run probe-defaults --image=curlimages/curl:8.22.0 --dry-run=server -o jsonpath='{.spec.containers[0].resources}'
kubectl -n bay run probe-big --image=curlimages/curl:8.22.0 --dry-run=server --overrides='{"spec":{"containers":[{"name":"probe-big","image":"curlimages/curl:8.22.0","resources":{"requests":{"cpu":"4","memory":"32Mi"},"limits":{"memory":"64Mi"}}}]}}'
```

The first command prints the injected values. The second ends with `exceeded quota`.

## Step 3: Stop sharing the host process namespace

```sh
kubectl -n bay patch deployment crane --type=json -p '[{"op":"remove","path":"/spec/template/spec/hostPID"}]'
kubectl -n bay rollout status deployment/crane
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-060/module-01/labs/lab-01
```

Destroy the lab when you are done:

```sh
astrona destroy ats-043-lab-060-01
```

# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-060/capstone/labs/lab-01
```

## Step 1: Quotas and default limits

Save the four objects as `tenants.yaml`:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: tenant-quota
  namespace: tenant-a
spec:
  hard:
    pods: "5"
    requests.cpu: 500m
    requests.memory: 512Mi
    limits.memory: 1Gi
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: tenant-quota
  namespace: tenant-b
spec:
  hard:
    pods: "3"
    requests.cpu: 250m
    requests.memory: 256Mi
    limits.memory: 512Mi
---
apiVersion: v1
kind: LimitRange
metadata:
  name: tenant-limits
  namespace: tenant-a
spec:
  limits:
    - type: Container
      defaultRequest:
        cpu: 50m
        memory: 32Mi
      default:
        memory: 128Mi
---
apiVersion: v1
kind: LimitRange
metadata:
  name: tenant-limits
  namespace: tenant-b
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
kubectl apply -f tenants.yaml
kubectl -n tenant-a describe resourcequota tenant-quota
kubectl -n tenant-b describe resourcequota tenant-quota
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-060/capstone/labs/lab-01
```

## Step 2: Cut the cross-namespace access

List who has access in `tenant-a`, then remove the binding that names the ServiceAccount of the other tenant:

```sh
kubectl -n tenant-a get rolebinding -o wide
kubectl -n tenant-a delete rolebinding shared-edit
kubectl auth can-i create deployments -n tenant-a --as=system:serviceaccount:tenant-b:ops-sa
kubectl auth can-i create deployments -n tenant-b --as=system:serviceaccount:tenant-b:ops-sa
```

The first check prints `no`, the second `yes`.

## Step 3: Stop sharing the node

```sh
kubectl -n tenant-b patch deployment probe --type=json -p '[
  {"op":"remove","path":"/spec/template/spec/hostPID"},
  {"op":"remove","path":"/spec/template/spec/volumes"},
  {"op":"remove","path":"/spec/template/spec/containers/0/volumeMounts"}]'
kubectl -n tenant-b rollout status deployment/probe
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-060/capstone/labs/lab-01
```

Destroy the lab when you are done:

```sh
astrona destroy ats-043-capstone-060
```

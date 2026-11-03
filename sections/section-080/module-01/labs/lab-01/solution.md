# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-080/module-01/labs/lab-01
```

## Step 1: Test the open network

```sh
kubectl -n harbor exec deploy/probe -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://scout.harbor.svc
```

The call returns `200`, so no policy exists.

## Step 2: Isolate scout and allow shuttle

Save this as `harbor-policies.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: harbor
spec:
  podSelector: {}
  policyTypes:
    - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-shuttle-to-scout
  namespace: harbor
spec:
  podSelector:
    matchLabels:
      app: scout
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: shuttle
      ports:
        - protocol: TCP
          port: 9898
```

The first policy isolates every Pod in `harbor` for ingress. The second allows `shuttle` to reach `scout`. The port is the Pod port 9898, not the Service port 80.

```sh
kubectl apply -f harbor-policies.yaml
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-080/module-01/labs/lab-01
```

## Step 3: Test each caller

```sh
kubectl -n harbor exec deploy/shuttle -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://scout.harbor.svc
kubectl -n harbor exec deploy/probe -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://scout.harbor.svc
kubectl -n outpost exec deploy/drifter -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://scout.harbor.svc
```

The first call prints `200`. The other two wait for the timeout and print `000`. Destroy the lab when you are done:

```sh
astrona destroy ats-043-lab-080-01
```

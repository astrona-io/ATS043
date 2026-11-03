# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-080/capstone/labs/lab-01
```

## Step 1: Write the policies

Save this as `fleet-policies.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: fleet
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-egress
  namespace: fleet
spec:
  podSelector: {}
  policyTypes:
    - Egress
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
          podSelector:
            matchLabels:
              k8s-app: kube-dns
      ports:
        - protocol: UDP
          port: 53
        - protocol: TCP
          port: 53
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: shuttle-egress-to-scout
  namespace: fleet
spec:
  podSelector:
    matchLabels:
      app: shuttle
  policyTypes:
    - Egress
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: scout
      ports:
        - protocol: TCP
          port: 9898
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: scout-ingress-from-shuttle
  namespace: fleet
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
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: probe-ingress-from-drifter
  namespace: fleet
spec:
  podSelector:
    matchLabels:
      app: probe
  policyTypes:
    - Ingress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: outpost
          podSelector:
            matchLabels:
              app: drifter
      ports:
        - protocol: TCP
          port: 8080
```

- `default-deny-all` selects every Pod and lists both policy types, so nothing is allowed until another policy adds it.
- `allow-dns-egress` uses one `to` entry with a namespace selector and a Pod selector together, so only the kube-dns Pods match.
- `shuttle-egress-to-scout` and `scout-ingress-from-shuttle` open both ends of one connection. Both use the Pod port 9898.
- `probe-ingress-from-drifter` puts the namespace selector and the Pod selector in one `from` entry, so both must match. `intruder` fails the Pod selector.

```sh
kubectl apply -f fleet-policies.yaml
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-080/capstone/labs/lab-01
```

## Step 2: Test the paths

```sh
kubectl -n fleet exec deploy/shuttle -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://scout.fleet.svc
kubectl -n outpost exec deploy/drifter -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://probe.fleet.svc
kubectl -n outpost exec deploy/intruder -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://probe.fleet.svc
kubectl -n fleet exec deploy/crane -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://beacon.outpost.svc
```

The first two print `200`. The last two wait for the timeout and print `000`. Destroy the lab when you are done:

```sh
astrona destroy ats-043-capstone-080
```

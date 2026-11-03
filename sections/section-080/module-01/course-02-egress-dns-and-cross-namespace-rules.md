# Egress, DNS And Cross-Namespace Rules

Ingress rules protect a Pod from callers. Egress rules limit what a Pod may call, which matters when a workload is compromised and tries to reach other Pods, other namespaces or the internet. This part shows how egress isolation works, why it breaks DNS until you allow it, how a namespace selector and a Pod selector combine and what a NetworkPolicy cannot do.

## Egress isolation

A policy that lists `Egress` in `policyTypes` isolates the selected Pods for outgoing connections. The Pods may then start only the connections that an `egress` rule allows. The rule has `to` and `ports`, with the same peer types as an ingress `from`.

A connection between two isolated Pods needs an egress rule at the source and an ingress rule at the destination. Each side is tested on its own.

<!-- astrona:playground:renew -->

Start with a clean namespace. Remove any policy from the previous part:

```sh
kubectl -n starfleet delete networkpolicy --all
```

Save this as `default-deny-egress.yaml`. It isolates every Pod in `starfleet` for egress and allows nothing:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-egress
  namespace: starfleet
spec:
  podSelector: {}
  policyTypes:
    - Egress
```

```sh
kubectl apply -f default-deny-egress.yaml
kubectl -n starfleet exec deploy/shuttle -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://scout.starfleet.svc
```

The call fails, but not because the connection to `scout` was refused. The name `scout.starfleet.svc` could not be resolved, because the lookup is also an outgoing connection.

## Allow DNS

Pods resolve names by sending queries to the cluster DNS Service, which runs as Pods in `kube-system` with the label `k8s-app=kube-dns`. Queries use port 53 over UDP, and over TCP when an answer is large. An isolated Pod needs an egress rule for both. Save this as `allow-dns.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
  namespace: starfleet
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
```

Apply it and look up a name from `shuttle`:

```sh
kubectl apply -f allow-dns.yaml
kubectl -n starfleet exec deploy/shuttle -- nslookup scout.starfleet.svc.cluster.local
kubectl -n starfleet exec deploy/shuttle -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://scout.starfleet.svc
```

The lookup works and the `curl` call still fails. DNS is allowed, and the connection to `scout` is not. Save this as `allow-shuttle-egress.yaml`, which opens only `shuttle` to `scout` on its Pod port:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-shuttle-egress
  namespace: starfleet
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
```

```sh
kubectl apply -f allow-shuttle-egress.yaml
kubectl -n starfleet exec deploy/shuttle -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 http://scout.starfleet.svc
```

The call returns `200`, because no policy isolates `scout` for ingress, so the destination end is open. Add an ingress deny and the same call fails again until `scout` allows `shuttle`.

## One peer or two

A namespace is selected by its labels. Kubernetes sets the label `kubernetes.io/metadata.name` on every namespace to the namespace's name, so it is the reliable way to name one.

The shape of the list decides the meaning. Both of these peer lists are valid, and they allow different traffic.

One entry with both selectors allows only `drifter` Pods in `outpost`:

```yaml
from:
  - namespaceSelector:
      matchLabels:
        kubernetes.io/metadata.name: outpost
    podSelector:
      matchLabels:
        app: drifter
```

Two entries allow every Pod in `outpost`, and also every Pod labeled `app: drifter` in the policy's own namespace:

```yaml
from:
  - namespaceSelector:
      matchLabels:
        kubernetes.io/metadata.name: outpost
  - podSelector:
      matchLabels:
        app: drifter
```

One dash decides the difference. When a policy allows more traffic than expected, read the dashes first.

Namespace labels other than the name can be changed by anyone who can edit the namespace. A policy that trusts a custom label is only as strong as who may change it.

## What a NetworkPolicy does not do

- It does not look inside the traffic. A rule for port 8080 allows every HTTP path and method on that port.
- It does not encrypt traffic or check identity. A Pod that is allowed can send to the destination whatever it holds.
- It does not control Pods that use `hostNetwork`, because those Pods use the node's address. Support for that case depends on the plugin.
- It does not replace the control of who may call the API server. A Pod with a ServiceAccount token still reaches the API server unless a rule blocks that address.
- It does not need a rule for replies. The reply traffic of an allowed connection is allowed without a separate rule.

## Common pitfalls

> [!WARNING]
> - Isolating egress and forgetting DNS. Every name lookup then fails and the symptom looks like a broken backend.
> - Allowing DNS on UDP only. Large answers use TCP.
> - Writing the namespace selector and the Pod selector as two entries when one was meant. The rule then allows much more.
> - Trusting a rule on a namespace label that other users can edit.
> - Allowing egress at the source and forgetting that the destination may be isolated for ingress.

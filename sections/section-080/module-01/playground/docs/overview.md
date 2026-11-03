# Overview: Traffic Isolation With NetworkPolicy (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35. Its network plugin, kindnet, enforces NetworkPolicy.
- The namespace `starfleet` with `scout` (port 9898), `probe` (port 8080) and `shuttle`. `scout` and `probe` have Services on port 80.
- The namespace `outpost` with `drifter`.
- No NetworkPolicy. Every request succeeds at the start.
- Use `kubectl exec deploy/<name> -- curl -s -o /dev/null -w '%{http_code}\n' --max-time 5 <url>` to test a connection. A blocked call waits for the timeout and prints `000`.

## Practice tasks

- Apply a default deny for ingress in `starfleet` and watch each caller fail.
- Allow only `shuttle` to reach `scout` and check `probe` and `drifter`.
- Write a rule for port 80 and see it match nothing. Change it to the Pod port.
- Isolate egress and watch name lookups fail. Add the DNS rule.
- Write a `from` entry with a namespace selector and a Pod selector together, then as two entries, and test which callers pass.
- Delete all policies with `kubectl -n starfleet delete networkpolicy --all` and start again.

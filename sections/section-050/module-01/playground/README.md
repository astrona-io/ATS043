# Secrets And Sensitive Configuration - Playground

- **Slug:** ats-043-playground-050-01
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads in `starfleet` and `outpost`. You are the cluster administrator and can read etcd from the control plane Pod.

## Run it

```sh
astrona run -c .
astrona destroy ats-043-playground-050-01
```

`astrona destroy` takes the environment name, not the config path.

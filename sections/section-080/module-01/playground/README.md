# Traffic Isolation With NetworkPolicy - Playground

- **Slug:** ats-043-playground-080-01
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads in `starfleet` and `outpost`. No NetworkPolicy exists. The default network plugin, kindnet, enforces NetworkPolicy.

## Run it

```sh
astrona run -c .
astrona destroy ats-043-playground-080-01
```

`astrona destroy` takes the environment name, not the config path.

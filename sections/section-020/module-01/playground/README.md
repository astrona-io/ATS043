# Pod Security Admission Decisions - Playground

- **Slug:** ats-043-playground-020-01
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads in `starfleet` and `outpost`. No namespace has a Pod Security label, so PSA applies its default (`privileged`).

## Run it

```sh
astrona run -c .
astrona destroy ats-043-playground-020-01
```

`astrona destroy` takes the environment name, not the config path.

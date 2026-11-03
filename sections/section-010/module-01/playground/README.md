# Pod Security Profiles - Playground

- **Slug:** ats-043-playground-010-01
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`) with the Starfleet workloads (`scout`, `probe`, `shuttle` in `starfleet`, `drifter` in `outpost`). None of them sets a `securityContext`, and no namespace enforces a Pod Security level.

## Run it

```sh
astrona run -c .
astrona destroy ats-043-playground-010-01
```

`astrona destroy` takes the environment name, not the config path.

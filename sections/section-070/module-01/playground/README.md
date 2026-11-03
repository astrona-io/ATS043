# Audit Policy And Security Evidence - Playground

- **Slug:** ats-043-playground-070-01
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads in `starfleet` and `outpost`. Audit logging is off. Reach the control plane node with `podman exec` (or `docker exec`) on the container `astro-ats-043-playground-070-01-control-plane`.

## Run it

```sh
astrona run -c .
astrona destroy ats-043-playground-070-01
```

`astrona destroy` takes the environment name, not the config path.

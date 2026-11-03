# Section 060: Isolation

Namespaces separate names and policy scope, and they leave the nodes, the kernel and the default network shared. This section shows what Pods still share, how quotas and default limits bound a tenant, how taints and RuntimeClass separate workloads on nodes and which permissions join namespaces.

**Exam objective covered:** Isolation (Kubernetes Security Fundamentals, KCSA)

---

## What You Will Master

- State what a namespace separates and what it does not
- Bound a tenant with ResourceQuota and LimitRange
- Find Pods that share the host process, network or filesystem
- Choose taints or RuntimeClass to separate workloads on nodes

---

## The Learning Path

### 1. Isolation And Segmentation
*   **Module Reader:** **[Module 1: Isolation And Segmentation](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-060/module-01/playground` - a kind cluster with the Starfleet workloads where you can try quotas, limit ranges, taints and runtime classes.
*   **Module Lab:** `sections/section-060/module-01/labs/lab-01` - add a quota and default limits and remove host process sharing.

### Capstone
*   **Capstone Lab:** `sections/section-060/capstone/labs/lab-01` - bound two tenants, cut cross-namespace access and remove host sharing.
*   **Knowledge Check:** `sections/section-060/quiz.yaml`

The labs and playgrounds are UNTESTED: they were built and checked statically only.

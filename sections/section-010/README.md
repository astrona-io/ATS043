# Section 010: Pod Security Standards

Pod Security Standards (PSS) are three named sets of pod rules: Privileged, Baseline and Restricted. This section explains which pod fields each profile controls, what the kubelet and container runtime do with a security context, and how to bring a workload up to the Restricted profile.

**Exam objective covered:** Pod Security Standards (Kubernetes Security Fundamentals, KCSA)

---

## What You Will Master

- Compare the Privileged, Baseline and Restricted profiles
- Explain what each securityContext field changes on the node
- Fix a text user name, a writable path and a capability list so a workload passes Restricted
- Distinguish a compliant pod specification from a secure application

---

## The Learning Path

### 1. Pod Security Profiles
*   **Module Reader:** **[Module 1: Pod Security Profiles](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-01/playground` - a kind cluster with the Starfleet workloads, none hardened and no profile enforced.
*   **Module Lab:** `sections/section-010/module-01/labs/lab-01` - make three Deployments in a restricted namespace meet the level.

### Capstone
*   **Capstone Lab:** `sections/section-010/capstone/labs/lab-01` - label a namespace and harden three Deployments without touching a second namespace.
*   **Knowledge Check:** `sections/section-010/quiz.yaml`

The labs and playgrounds are UNTESTED: they were built and checked statically only.

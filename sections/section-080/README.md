# Section 080: Network Policy

By default every Pod can talk to every other Pod. NetworkPolicy lets you restrict that. This section shows how a policy selects Pods, how allow rules add up, how egress rules and DNS work and how the selector forms combine across namespaces.

**Exam objective covered:** Network Policy (Kubernetes Security Fundamentals, KCSA)

---

## What You Will Master

- Explain how a NetworkPolicy selects Pods and changes what they accept
- Write allow rules that use the Pod port and the right selectors
- Write egress rules that keep DNS working
- Combine namespace and Pod selectors with the intended meaning

---

## The Learning Path

### 1. Traffic Isolation With NetworkPolicy
*   **Module Reader:** **[Module 1: Traffic Isolation With NetworkPolicy](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-080/module-01/playground` - a kind cluster with the Starfleet workloads and no NetworkPolicy, on a network plugin that enforces policies.
*   **Module Lab:** `sections/section-080/module-01/labs/lab-01` - default deny ingress and allow only one caller.

### Capstone
*   **Capstone Lab:** `sections/section-080/capstone/labs/lab-01` - lock down a namespace with default deny, DNS and narrow allow rules.
*   **Knowledge Check:** `sections/section-080/quiz.yaml`

The labs and playgrounds are UNTESTED: they were built and checked statically only.

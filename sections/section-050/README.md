# Section 050: Secrets

A Secret is stored, served and delivered by the cluster, and each step can expose it. This section shows what etcd holds, how to enable encryption at rest, how environment variables and volumes differ, and how to rotate a credential.

**Exam objective covered:** Secrets (Kubernetes Security Fundamentals, KCSA)

---

## What You Will Master

- Explain why base64 is not protection
- Describe what encryption at rest changes and what it does not
- Predict how a running Pod sees a Secret change
- Rotate a credential and find the exposure paths

---

## The Learning Path

### 1. Secrets And Sensitive Configuration
*   **Module Reader:** **[Module 1: Secrets And Sensitive Configuration](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-050/module-01/playground` - a kind cluster with the Starfleet workloads where you can read etcd from the control plane Pod.
*   **Module Lab:** `sections/section-050/module-01/labs/lab-01` - rotate a Secret, switch to volume delivery and make it immutable.

### Capstone
*   **Capstone Lab:** `sections/section-050/capstone/labs/lab-01` - rotate two Secrets, fix delivery and delete unused Secrets.
*   **Knowledge Check:** `sections/section-050/quiz.yaml`

The labs and playgrounds are UNTESTED: they were built and checked statically only.

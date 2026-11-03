# Section 020: Pod Security Admissions

Pod Security Admission is the built-in admission controller that applies the Pod Security Standards to pods. This section explains the namespace labels, the three modes, how to roll out a level safely and what the controller does not cover.

**Exam objective covered:** Pod Security Admissions (Kubernetes Security Fundamentals, KCSA)

---

## What You Will Master

- Write namespace labels that select a level and a version
- Explain what enforce, audit and warn each do
- Plan a safe rollout with a server-side dry run
- Name the exemptions and the limits of the controller

---

## The Learning Path

### 1. Pod Security Admission
*   **Module Reader:** **[Module 1: Pod Security Admission](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-020/module-01/playground` - a kind cluster with the Starfleet workloads and no Pod Security labels.
*   **Module Lab:** `sections/section-020/module-01/labs/lab-01` - label a namespace for baseline enforcement and fix the workload that breaks it.

### Capstone
*   **Capstone Lab:** `sections/section-020/capstone/labs/lab-01` - configure three namespaces with different modes and fix two workloads.
*   **Knowledge Check:** `sections/section-020/quiz.yaml`

The labs and playgrounds are UNTESTED: they were built and checked statically only.

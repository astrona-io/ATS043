# Section 070: Audit

Audit logging records who asked the API server to do what and what the answer was. This section shows how events, stages and levels work, how an ordered policy decides what is written, how to enable the log on a control plane and how to keep it from leaking secrets or losing evidence.

**Exam objective covered:** Audit (Kubernetes Security Fundamentals, KCSA)

---

## What You Will Master

- Read an audit event and name the caller, verb, target and result
- Write an ordered policy with levels and omitted stages
- Keep secret values out of the log
- Name the ways evidence is lost and the controls against them

---

## The Learning Path

### 1. Audit Policy And Security Evidence
*   **Module Reader:** **[Module 1: Audit Policy And Security Evidence](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-070/module-01/playground` - a kind cluster with the Starfleet workloads and audit logging off, where you turn it on at the control plane node.
*   **Module Lab:** `sections/section-070/module-01/labs/lab-01` - enable audit logging with a policy that keeps secret values out of the log.

### Capstone
*   **Capstone Lab:** `sections/section-070/capstone/labs/lab-01` - write a policy for Secrets, ConfigMaps and reads and rotate the log.
*   **Knowledge Check:** `sections/section-070/quiz.yaml`

The labs and playgrounds are UNTESTED: they were built and checked statically only.

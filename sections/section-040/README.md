# Section 040: Authorization

Authorization decides what an authenticated identity may do. This section explains how RBAC rules are matched and combined, how to test any identity, and which permissions allow privilege escalation.

**Exam objective covered:** Authorization (Kubernetes Security Fundamentals, KCSA)

---

## What You Will Master

- Compare Role, ClusterRole, RoleBinding and ClusterRoleBinding
- Evaluate effective permissions with impersonation
- Identify verbs and bindings that allow privilege escalation
- Apply least privilege to users and ServiceAccounts

---

## The Learning Path

### 1. Authorization And Effective Permissions
*   **Module Reader:** **[Module 1: Authorization And Effective Permissions](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-040/module-01/playground` - a kind cluster with the Starfleet workloads, where you test identities with impersonation.
*   **Module Lab:** `sections/section-040/module-01/labs/lab-01` - replace a wildcard Role with exact rules and remove a public binding.

### Capstone
*   **Capstone Lab:** `sections/section-040/capstone/labs/lab-01` - remove four excessive grants without breaking required access.
*   **Knowledge Check:** `sections/section-040/quiz.yaml`

The labs and playgrounds are UNTESTED: they were built and checked statically only.

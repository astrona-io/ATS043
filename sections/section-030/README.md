# Section 030: Authentication

Authentication is the first check on every API request. This section explains how the API server derives an identity from a certificate, a token or no credential, how workloads get bound ServiceAccount tokens, and how people receive client certificates.

**Exam objective covered:** Authentication (Kubernetes Security Fundamentals, KCSA)

---

## What You Will Master

- Name the credential types the API server accepts
- Distinguish a 401 from a 403
- Explain bound ServiceAccount tokens and automounting
- Issue and deny client certificates through the CSR API

---

## The Learning Path

### 1. Authentication And Workload Credentials
*   **Module Reader:** **[Module 1: Authentication And Workload Credentials](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-030/module-01/playground` - a kind cluster with the Starfleet workloads, where you act as the cluster administrator.
*   **Module Lab:** `sections/section-030/module-01/labs/lab-01` - approve a CSR and remove unneeded token credentials from a workload.

### Capstone
*   **Capstone Lab:** `sections/section-030/capstone/labs/lab-01` - approve one CSR, deny another, limit tokens and delete legacy Secrets.
*   **Knowledge Check:** `sections/section-030/quiz.yaml`

The labs and playgrounds are UNTESTED: they were built and checked statically only.

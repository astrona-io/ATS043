---
draft: true
exam_objectives:
  - Authentication
---
# Summary

Authentication establishes a caller identity through the configured credential mechanism. ServiceAccounts identify workloads, and projected tokens can limit audience and lifetime. A valid token still needs careful protection.

Identity does not grant every requested action. Authorization and admission remain separate checks. Avoid mounting unnecessary credentials and investigate failures at the stage indicated by the evidence.

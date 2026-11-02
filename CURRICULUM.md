# Curriculum Coverage

Exam: Kubernetes and Cloud Native Associate (KCSA). Domain: Kubernetes Security Fundamentals (22%).

Verified against the [official objectives](https://training.linuxfoundation.org/certification/kubernetes-and-cloud-native-security-associate-kcsa/) on 2026-10-11. Module titles and questions are original teaching material, not official exam questions.

| Section | Official objective | Modules | Status |
| --- | --- | --- | --- |
| 010 | Pod Security Standards | 1 | Written; review pending |
| 020 | Pod Security Admissions | 1 | Written; review pending |
| 030 | Authentication | 1 | Written; review pending |
| 040 | Authorization | 1 | Written; review pending |
| 050 | Secrets | 1 | Written; review pending |
| 060 | Isolation and Segmentation | 1 | Written; review pending |
| 070 | Audit Logging | 1 | Written; review pending |
| 080 | Network Policy | 1 | Written; review pending |

| Section / module | Module | Teaching lessons | Measurable outcomes |
| --- | --- | --- | --- |
| 010 / 01 | Pod Security Profiles | 1 | Compare Privileged, Baseline and Restricted profiles.; Explain the purpose and limits of security-context fields.; Relate image users and writable paths to profile compatibility.; Distinguish compliant configuration from complete application security. |
| 020 / 01 | Pod Security Admission Decisions | 1 | Distinguish enforce, warn and audit policy modes.; Explain namespace policy labels and version selection.; Predict the effect of policy changes on new workload Pods.; Separate Pod Security Admission from RBAC and image verification. |
| 030 / 01 | Authentication And Workload Credentials | 1 | Distinguish established identity from granted API permission.; Explain ServiceAccount token audience and lifetime.; Identify unnecessary credential mounting and disclosure paths.; Relate authentication failure to the actual credential mechanism. |
| 040 / 01 | Authorization And Effective Permissions | 1 | Compare Role, ClusterRole, RoleBinding and ClusterRoleBinding.; Evaluate namespace scope, verbs, resources and subjects.; Explain additive grants and indirect privilege.; Apply least privilege to a workload identity. |
| 050 / 01 | Secret Delivery And Credential Lifecycle | 1 | Explain why Secret encoding is not encryption.; Compare environment and mounted-file update behavior.; Identify authorization and diagnostic exposure risks.; Describe rotation that updates consumers and revokes old authority. |
| 060 / 01 | Isolation And Namespace Segmentation | 1 | Distinguish namespace scope from physical or kernel isolation.; Compare API, network, process and resource controls.; Relate shared-node trust to workload compromise.; Identify residual access through legitimate dependencies. |
| 070 / 01 | Audit Policy And Security Evidence | 1 | Explain what Kubernetes audit events record.; Compare Metadata, Request and RequestResponse audit detail.; Relate audit retention and protection to investigation.; Distinguish API evidence from runtime and application evidence. |
| 080 / 01 | NetworkPolicy Semantics And Verification | 1 | Explain Pod selection and direction-specific network isolation.; Evaluate additive allowed rules and selector structure.; Relate DNS and dependencies to egress requirements.; Distinguish declared policy from actual implementation enforcement. |

Every section begins with an introduction. Every module ends with a summary before the next module. YAML checkpoint banks follow selected section summaries; a domain review bank closes the course. They are indexed separately for future application integration.

This course has no labs or playgrounds, as requested by the maintainer. All material is readable without a cluster. Technical content remains draft until review; no runtime execution or lab validation is claimed.

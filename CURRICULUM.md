# Curriculum Coverage

Exam: Kubernetes and Cloud Native Associate (KCSA). Domain: Kubernetes Security Fundamentals (22%).

Verified against the [official objectives](https://training.linuxfoundation.org/certification/kubernetes-and-cloud-native-security-associate-kcsa/) on 2026-10-11. Module titles and questions are original teaching material, not official exam questions.

| Section | Official objective | Modules | Status |
| --- | --- | --- | --- |
| 010 | Pod Security Standards | 1 | Built; labs untested; review pending |
| 020 | Pod Security Admissions | 1 | Built; labs untested; review pending |
| 030 | Authentication | 1 | Built; labs untested; review pending |
| 040 | Authorization | 1 | Built; labs untested; review pending |
| 050 | Secrets | 1 | Built; labs untested; review pending |
| 060 | Isolation and Segmentation | 1 | Built; labs untested; review pending |
| 070 | Audit Logging | 1 | Built; labs untested; review pending |
| 080 | Network Policy | 1 | Built; labs untested; review pending |

| Section / module | Module | Teaching lessons | Measurable outcomes |
| --- | --- | --- | --- |
| 010 / 01 | Pod Security Profiles | 1 | Compare the Privileged, Baseline and Restricted profiles; Explain what each securityContext field changes on the node; Fix a text user name, a writable path and a capability list so a workload passes Restricted; Distinguish a compliant pod specification from a secure application. |
| 020 / 01 | Pod Security Admission | 1 | Write namespace labels that select a level and a version; Explain what enforce, audit and warn each do; Plan a safe rollout with a server-side dry run; Name the exemptions and the limits of the controller. |
| 030 / 01 | Authentication And Workload Credentials | 1 | Name the credential types the API server accepts; Distinguish a 401 from a 403; Explain bound ServiceAccount tokens and automounting; Issue and deny client certificates through the CSR API. |
| 040 / 01 | Authorization And Effective Permissions | 1 | Compare Role, ClusterRole, RoleBinding and ClusterRoleBinding; Evaluate effective permissions with impersonation; Identify verbs and bindings that allow privilege escalation; Apply least privilege to users and ServiceAccounts. |
| 050 / 01 | Secrets And Sensitive Configuration | 1 | Explain why base64 is not protection; Describe what encryption at rest changes and what it does not; Predict how a running Pod sees a Secret change; Rotate a credential and find the exposure paths. |
| 060 / 01 | Isolation And Segmentation | 1 | State what a namespace separates and what it does not; Bound a tenant with ResourceQuota and LimitRange; Find Pods that share the host process, network or filesystem; Choose taints or RuntimeClass to separate workloads on nodes. |
| 070 / 01 | Audit Policy And Security Evidence | 1 | Read an audit event and name the caller, verb, target and result; Write an ordered policy with levels and omitted stages; Keep secret values out of the log; Name the ways evidence is lost and the controls against them. |
| 080 / 01 | Traffic Isolation With NetworkPolicy | 1 | Explain how a NetworkPolicy selects Pods and changes what they accept; Write allow rules that use the Pod port and the right selectors; Write egress rules that keep DNS working; Combine namespace and Pod selectors with the intended meaning. |

Every section begins with an introduction. Every module ends with a summary before the next module. YAML checkpoint banks follow selected section summaries; a domain review bank closes the course. They are indexed separately for future application integration.

Each section has a playground, a module lab, a capstone lab and a quiz. Labs and playgrounds are untested (static checks only); technical content remains draft until review.

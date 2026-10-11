---
draft: true
exam_objectives:
  - Network Policy
---
# Summary

NetworkPolicy selects Pods and defines supported allowances for isolated ingress and egress directions. Rules combine additively, and a source's egress and destination's ingress can both affect a connection.

Selector structure, ports and required dependencies determine the intended paths. API acceptance is not evidence of actual enforcement; a supporting network implementation must realize the policy. Connection control remains distinct from encryption and application authorization.

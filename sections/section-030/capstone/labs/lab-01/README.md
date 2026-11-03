---
estimated_duration: 30m
---

# Lab: Authentication And Workload Credentials Capstone

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-030/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-030/capstone/labs/lab-01
astrona destroy ats-043-capstone-030
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-rowan-certificate.sh` | CSR rowan-csr is approved with CN=rowan, O=cadets |
| `validate-intruder-denied.sh` | CSR intruder-csr is denied and has no certificate |
| `validate-rowan-permissions.sh` | rowan can list pods in fleet and cannot delete them |
| `validate-shuttle-no-token.sh` | shuttle-sa disables automounting and shuttle pods carry no token |
| `validate-drifter-keeps-token.sh` | drifter still mounts a token and is available |
| `validate-legacy-secrets.sh` | Both legacy token Secrets in fleet are deleted |

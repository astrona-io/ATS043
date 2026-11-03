---
estimated_duration: 30m
---

# Lab: Audit Policy And Security Evidence Capstone

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-070/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-070/capstone/labs/lab-01
astrona destroy ats-043-capstone-070
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-audit-logging-enabled.sh` | The API server runs with an audit policy file and writes /var/log/kubernetes/audit/audit.log |
| `validate-rotation-flags.sh` | The log is rotated with maxsize, maxage and maxbackup so it cannot fill the disk or grow without limit |
| `validate-secret-metadata-only.sh` | A Secret read is recorded at Metadata level with no request or response body |
| `validate-configmaps-at-request.sh` | A ConfigMap create is recorded at Request level with the request body and no response body |
| `validate-reads-dropped.sh` | Routine reads of Pods and ConfigMaps are not recorded while changes still are |
| `validate-noise-dropped.sh` | Health checks and the RequestReceived stage are not recorded |

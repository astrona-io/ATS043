---
estimated_duration: 25m
---

# Lab: Audit Policy And Security Evidence

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-070/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-070/module-01/labs/lab-01
astrona destroy ats-043-lab-070-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-audit-logging-enabled.sh` | The API server runs with an audit policy file and writes /var/log/kubernetes/audit/audit.log |
| `validate-secret-metadata-only.sh` | A Secret read is recorded at Metadata level with no request or response body |
| `validate-deployment-bodies-recorded.sh` | Creating and deleting a Deployment are recorded at RequestResponse with both bodies |
| `validate-noise-dropped.sh` | Health checks and the RequestReceived stage are not recorded |

---
estimated_duration: 30m
---

# Lab: Pod Security Admission Capstone

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-043-capstone-020
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-alpha-labels.sh` | alpha enforces restricted at v1.35 and the misspelled label is gone |
| `validate-beta-labels.sh` | beta enforces baseline and warns and audits restricted |
| `validate-gamma-labels.sh` | gamma warns and audits baseline and has no enforce label |
| `validate-web-meets-restricted.sh` | Every pod of web in alpha meets the restricted level |
| `validate-batch-meets-baseline.sh` | Every pod of batch in beta runs and meets the baseline level |
| `validate-admission-decisions.sh` | Privileged and hostNetwork pods are refused where enforced and gamma stays open |
| `validate-agent-untouched.sh` | agent in gamma still runs privileged with hostNetwork |

---
estimated_duration: 20m
---

# Lab: Pod Security Admission Decisions

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-043-lab-020-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-dock-labels.sh` | dock enforces baseline (version v1.35) and warns and audits restricted |
| `validate-tug-meets-baseline.sh` | Every pod of tug runs and meets the baseline level |
| `validate-privileged-pod-refused.sh` | A privileged pod is refused in dock |
| `validate-baseline-pod-accepted.sh` | A pod that meets baseline but not restricted is accepted in dock |
| `validate-yard-untouched.sh` | yard has no enforce label and forklift still runs |

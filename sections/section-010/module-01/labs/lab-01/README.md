---
estimated_duration: 20m
---

# Lab: Pod Security Profiles

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-010/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-043-lab-010-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-fuel-meets-restricted.sh` | Every pod of fuel runs and meets the restricted level |
| `validate-cargo-meets-restricted.sh` | Every pod of cargo runs and meets the restricted level |
| `validate-relay-meets-restricted.sh` | Every pod of relay runs and meets the restricted level |
| `validate-namespace-still-enforces-restricted.sh` | The hangar namespace still enforces the restricted level |
| `validate-workloads-not-replaced.sh` | The three Deployments exist with their original images |

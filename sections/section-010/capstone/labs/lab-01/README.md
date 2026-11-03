---
estimated_duration: 30m
---

# Lab: Pod Security Standards Capstone

Graded capstone lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-010/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-043-capstone-010
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-beacon-meets-restricted.sh` | Every pod of beacon in orbit runs and meets the restricted level |
| `validate-relay-meets-restricted.sh` | Every pod of relay in orbit runs and meets the restricted level |
| `validate-cargo-meets-restricted.sh` | Every pod of cargo in orbit runs and meets the restricted level |
| `validate-orbit-labels.sh` | orbit enforces, warns and audits restricted with a pinned enforce version |
| `validate-privileged-pod-refused.sh` | A privileged pod is refused in orbit |
| `validate-workshop-untouched.sh` | workshop still runs tools and does not enforce baseline or restricted |
| `validate-images-unchanged.sh` | The three Deployments in orbit keep their images |

---
estimated_duration: 20m
---

# Lab: Traffic Isolation With NetworkPolicy

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-080/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-080/module-01/labs/lab-01
astrona destroy ats-043-lab-080-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-shuttle-allowed.sh` | shuttle in harbor reaches scout on its Pod port |
| `validate-probe-blocked.sh` | probe in the same namespace is blocked from scout |
| `validate-drifter-blocked.sh` | drifter in outpost is blocked from scout |
| `validate-scout-available.sh` | scout in harbor is still available |

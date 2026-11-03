---
estimated_duration: 35m
---

# Lab: Network Isolation Capstone

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-080/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-080/capstone/labs/lab-01
astrona destroy ats-043-capstone-080
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-shuttle-scout-allowed.sh` | shuttle reaches scout by name with DNS working |
| `validate-drifter-probe-allowed.sh` | drifter in outpost reaches probe on port 8080 |
| `validate-shuttle-probe-blocked.sh` | shuttle is blocked from probe |
| `validate-drifter-scout-blocked.sh` | drifter is blocked from scout |
| `validate-intruder-probe-blocked.sh` | intruder in outpost is blocked from probe |
| `validate-crane-egress-blocked.sh` | crane cannot reach beacon in outpost |

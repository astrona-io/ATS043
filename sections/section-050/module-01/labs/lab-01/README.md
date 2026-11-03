---
estimated_duration: 20m
---

# Lab: Secrets And Sensitive Configuration

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/module-01/labs/lab-01
astrona destroy ats-043-lab-050-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-rotated.sh` | Secret db-password holds new-value and the running scout pod reads new-value |
| `validate-volume-delivery.sh` | scout gets the password from a read-only Secret volume at /etc/scout and has no secret environment variable |
| `validate-immutable.sh` | Secret db-password is immutable |
| `validate-scout-available.sh` | Deployment scout in vault is available |

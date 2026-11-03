---
estimated_duration: 30m
---

# Lab: Secrets Capstone

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/capstone/labs/lab-01
astrona destroy ats-043-capstone-050
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-shuttle-file.sh` | shuttle reads token-2 from a read-only volume at /etc/shuttle and has no secret environment variable |
| `validate-probe-no-subpath.sh` | probe mounts probe-key without subPath and reads key-2 |
| `validate-immutable.sh` | api-token and probe-key hold their new values and are immutable |
| `validate-unused-removed.sh` | The unused Secrets old-api-token and spare-ssh-key are deleted and used Secrets remain |
| `validate-available.sh` | shuttle and probe are available |

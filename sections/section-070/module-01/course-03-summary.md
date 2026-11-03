# Summary

An audit event is a JSON line that records the authenticated caller, the verb, the target and the response status of one request to the API server. Each request can produce events at four stages. `RequestReceived` has no response status, so count actions from `ResponseComplete`. The policy sets one of four levels: `None`, `Metadata`, `Request` and `RequestResponse`. The first matching rule decides, and a request that matches no rule writes no event. A policy needs a `rules` field, and the API server needs `--audit-policy-file` and `--audit-log-path` plus volumes that make both reachable.

Request and response bodies can hold secret values, so Secrets belong at `Metadata`. Rule order, noise filters and `omitStages` decide how much data the log holds. The log backend rotates files with size, age and backup flags, and the webhook backend sends events to another system in `batch`, `blocking` or `blocking-strict` mode. The log is only as safe as its path: node access, `hostPath` volumes and API server manifest changes can read it or remove future events.

- Order rules from specific to broad.
- Keep secret values out of the log with `Metadata`.
- Ship events off the node and alert when they stop.
- The log shows API requests, not what happened inside a container.

<!-- astrona:playground:destroy -->

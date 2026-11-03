# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab has not been run yet; the commands are checked statically only.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-010/module-01/labs/lab-01
```

`astrona submit` right after the start shows one passing check. `workloads-not-replaced` and `namespace-still-enforces-restricted` pass because nothing has changed yet. They are your guards.

## Step 1: Read what restricted requires

Ask the API server which pods break the level. A server-side dry run changes nothing:

```sh
kubectl label --dry-run=server --overwrite namespace hangar pod-security.kubernetes.io/enforce=restricted
```

The output is a warning that lists each pod and the controls it violates, for example `allowPrivilegeEscalation != false`, `unrestricted capabilities`, `runAsNonRoot != true` and `seccompProfile`.

## Step 2: Fix fuel

Patch the Deployment with a JSON patch that adds the container security context:

```sh
kubectl -n hangar patch deployment fuel --type=json -p '[{"op":"add","path":"/spec/template/spec/containers/0/securityContext","value":{"runAsNonRoot":true,"runAsUser":10001,"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}}]'
kubectl -n hangar rollout status deployment/fuel
```

A text user name in the image is why `runAsUser` is numeric: `runAsNonRoot` cannot be proven for a name. Submit:

```sh
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-010/module-01/labs/lab-01
```

`fuel-meets-restricted` now passes.

## Step 3: Fix cargo

Remove the `hostPath` volume and its mount, and add the same security context:

```sh
kubectl -n hangar patch deployment cargo --type=json -p '[{"op":"remove","path":"/spec/template/spec/volumes"},{"op":"remove","path":"/spec/template/spec/containers/0/volumeMounts"},{"op":"add","path":"/spec/template/spec/containers/0/securityContext","value":{"runAsNonRoot":true,"runAsUser":10001,"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}}]'
kubectl -n hangar rollout status deployment/cargo
```

If the rollout does not finish, the replacement pod was rejected. Read the ReplicaSet events:

```sh
kubectl -n hangar describe replicaset -l app=cargo
```

## Step 4: Fix relay

Replace the privileged security context. A JSON patch `add` on an existing path replaces its value:

```sh
kubectl -n hangar patch deployment relay --type=json -p '[{"op":"add","path":"/spec/template/spec/containers/0/securityContext","value":{"runAsNonRoot":true,"runAsUser":10001,"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}}]'
kubectl -n hangar rollout status deployment/relay
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-010/module-01/labs/lab-01
```

All checks pass. Destroy the lab when you are done:

```sh
astrona destroy ats-043-lab-010-01
```

# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/capstone/labs/lab-01
```

## Step 1: Find the unused Secrets

```sh
kubectl -n depot get pods -o json | jq -r '[.items[].spec | (.volumes[]?.secret.secretName), (.containers[].env[]?.valueFrom.secretKeyRef.name), (.containers[].envFrom[]?.secretRef.name)] | map(select(. != null)) | unique[]'
kubectl -n depot get secrets
```

The first list shows the Secrets that pods reference: `api-token` and `probe-key`. The others are unused.

## Step 2: Rotate and redeliver shuttle

```sh
kubectl -n depot patch secret api-token --type=merge -p '{"stringData":{"token":"token-2"}}'
kubectl -n depot patch deployment shuttle --type=json -p '[{"op":"remove","path":"/spec/template/spec/containers/0/env"},{"op":"add","path":"/spec/template/spec/volumes","value":[{"name":"tok","secret":{"secretName":"api-token"}}]},{"op":"add","path":"/spec/template/spec/containers/0/volumeMounts","value":[{"name":"tok","mountPath":"/etc/shuttle","readOnly":true}]}]'
kubectl -n depot rollout status deployment/shuttle
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/capstone/labs/lab-01
```

## Step 3: Rotate and remount probe

```sh
kubectl -n depot patch secret probe-key --type=merge -p '{"stringData":{"key":"key-2"}}'
kubectl -n depot patch deployment probe --type=json -p '[{"op":"replace","path":"/spec/template/spec/containers/0/volumeMounts","value":[{"name":"key","mountPath":"/etc/probe/key","readOnly":true}]}]'
kubectl -n depot rollout status deployment/probe
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/capstone/labs/lab-01
```

## Step 4: Make immutable and clean up

```sh
kubectl -n depot patch secret api-token --type=merge -p '{"immutable":true}'
kubectl -n depot patch secret probe-key --type=merge -p '{"immutable":true}'
kubectl -n depot delete secret old-api-token spare-ssh-key
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/capstone/labs/lab-01
```

Destroy the lab when you are done:

```sh
astrona destroy ats-043-capstone-050
```

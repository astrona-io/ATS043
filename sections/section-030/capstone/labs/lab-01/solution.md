# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-030/capstone/labs/lab-01
```

## Step 1: Read, approve and deny

```sh
for name in rowan-csr intruder-csr; do
  echo "== $name"
  kubectl get csr "$name" -o jsonpath='{.spec.request}' | base64 -d | openssl req -noout -subject
done
kubectl certificate approve rowan-csr
kubectl certificate deny intruder-csr
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-030/capstone/labs/lab-01
```

The subject of `intruder-csr` has `O=system:masters`. The signer would copy that group into the certificate, and the group is bound to cluster-admin. Always deny it.

## Step 2: Grant read access

```sh
kubectl -n fleet create rolebinding rowan-view --clusterrole=view --user=rowan
kubectl --as=rowan auth can-i list pods -n fleet
kubectl --as=rowan auth can-i get secrets -n fleet
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-030/capstone/labs/lab-01
```

## Step 3: Remove the token from shuttle

```sh
kubectl -n fleet patch serviceaccount shuttle-sa --type=merge -p '{"automountServiceAccountToken":false}'
kubectl -n fleet rollout restart deployment/shuttle
kubectl -n fleet rollout status deployment/shuttle
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-030/capstone/labs/lab-01
```

## Step 4: Delete the legacy Secrets

```sh
kubectl -n fleet get secrets --field-selector type=kubernetes.io/service-account-token
kubectl -n fleet delete secret shuttle-sa-token drifter-sa-token
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-030/capstone/labs/lab-01
```

The pods of `drifter` use projected tokens, so deleting the legacy Secret does not remove their access. Destroy the lab when you are done:

```sh
astrona destroy ats-043-capstone-030
```

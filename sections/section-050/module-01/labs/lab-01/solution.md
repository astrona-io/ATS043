# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/module-01/labs/lab-01
```

## Step 1: Rotate the value

```sh
kubectl -n vault patch secret db-password --type=merge -p '{"stringData":{"password":"new-value"}}'
kubectl -n vault get secret db-password -o jsonpath='{.data.password}' | base64 -d
```

The running pod still has the old value in its environment.

## Step 2: Deliver it as a file

Save this as `scout-patch.yaml`:

```yaml
spec:
  template:
    spec:
      volumes:
        - name: db
          secret:
            secretName: db-password
      containers:
        - name: scout
          volumeMounts:
            - name: db
              mountPath: /etc/scout
              readOnly: true
```

Apply it. The environment variable is removed with a JSON patch because a strategic merge cannot delete a list entry:

```sh
kubectl -n vault patch deployment scout --patch-file scout-patch.yaml
kubectl -n vault patch deployment scout --type=json -p '[{"op":"remove","path":"/spec/template/spec/containers/0/env"}]'
kubectl -n vault rollout status deployment/scout
kubectl -n vault exec deploy/scout -- cat /etc/scout/password
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/module-01/labs/lab-01
```

## Step 3: Make the Secret immutable

```sh
kubectl -n vault patch secret db-password --type=merge -p '{"immutable":true}'
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS043.git -c sections/section-050/module-01/labs/lab-01
```

Destroy the lab when you are done:

```sh
astrona destroy ats-043-lab-050-01
```

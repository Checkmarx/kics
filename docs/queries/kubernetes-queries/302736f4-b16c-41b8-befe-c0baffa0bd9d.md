---
title: Shared Host PID Namespace
hide:
  toc: true
  navigation: true
---

<style>
  .highlight .hll {
    background-color: #ff171742;
  }
  .md-content {
    max-width: 1100px;
    margin: 0 auto;
  }
</style>

-   **Query id:** 302736f4-b16c-41b8-befe-c0baffa0bd9d
-   **Query name:** Shared Host PID Namespace
-   **Platform:** Kubernetes
-   **Severity:** <span style="color:#C00">High</span>
-   **Category:** Insecure Configurations
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/k8s/shared_host_pid_namespace)

### Description
Container should not share the host process ID namespace<br>
[Documentation](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Postitive test num. 1 - yaml file" hl_lines="9 6"
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  hostPID: true
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  volumes:
    - name: sec-ctx-vol
      emptyDir: { }
  containers:
    - name: sec-ctx-demo
      image: busybox
      command: [ "sh", "-c", "sleep 1h" ]
      volumeMounts:
        - name: sec-ctx-vol
          mountPath: /data/demo
      securityContext:
        allowPrivilegeEscalation: false
```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  hostPID: false
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  volumes:
    - name: sec-ctx-vol
      emptyDir: { }
  containers:
    - name: sec-ctx-demo
      image: busybox
      command: [ "sh", "-c", "sleep 1h" ]
      volumeMounts:
        - name: sec-ctx-vol
          mountPath: /data/demo
      securityContext:
        allowPrivilegeEscalation: false
```

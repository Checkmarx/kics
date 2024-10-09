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
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Insecure Configurations
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/200.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/200.html')">200</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/k8s/shared_host_pid_namespace)

### Description
Container should not share the host process ID namespace<br>
[Documentation](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="6"
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
```yaml title="Positive test num. 2 - yaml file" hl_lines="9"
apiVersion: serving.knative.dev/v1
kind: Configuration
metadata:
  name: dummy-config
  namespace: knative-sequence
spec:
  template:
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
```yaml title="Negative test num. 2 - yaml file"
apiVersion: serving.knative.dev/v1
kind: Configuration
metadata:
  name: dummy-config
  namespace: knative-sequence
spec:
  template:
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

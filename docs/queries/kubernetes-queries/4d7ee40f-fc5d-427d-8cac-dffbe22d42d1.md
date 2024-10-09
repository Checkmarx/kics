---
title: Authorization Mode Node Not Set
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

-   **Query id:** 4d7ee40f-fc5d-427d-8cac-dffbe22d42d1
-   **Query name:** Authorization Mode Node Not Set
-   **Platform:** Kubernetes
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Insecure Configurations
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/285.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/285.html')">285</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/k8s/authorization_mode_node_not_set)

### Description
When using kube-apiserver command, the 'authorization-mode' flag should have 'Node' mode<br>
[Documentation](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="11"
apiVersion: v1
kind: Pod
metadata:
  name: command-demo
  labels:
    purpose: demonstrate-command
spec:
  containers:
    - name: command-demo-container
      image: gcr.io/google_containers/kube-apiserver-amd64:v1.6.0
      command: ["kube-apiserver"]
      args: ["--authorization-mode=AlwaysAllow"]
  restartPolicy: OnFailure

```
```yaml title="Positive test num. 2 - yaml file" hl_lines="11"
apiVersion: v1
kind: Pod
metadata:
  name: command-demo
  labels:
    purpose: demonstrate-command
spec:
  containers:
    - name: command-demo-container
      image: gcr.io/google_containers/kube-apiserver-amd64:v1.6.0
      command: ["kube-apiserver"]
      args: ["--authorization-mode=RBAC"]
  restartPolicy: OnFailure

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
apiVersion: v1
kind: Pod
metadata:
  name: command-demo
  labels:
    purpose: demonstrate-command
spec:
  containers:
    - name: command-demo-container
      image: gcr.io/google_containers/kube-apiserver-amd64:v1.6.0
      command: ["kube-apiserver"]
      args: ["--authorization-mode=RBAC,Node"]
  restartPolicy: OnFailure

```
```yaml title="Negative test num. 2 - yaml file"
apiVersion: v1
kind: Pod
metadata:
  name: command-demo
  labels:
    purpose: demonstrate-command
spec:
  containers:
    - name: command-demo-container
      image: gcr.io/google_containers/kube-apiserver-amd64:v1.6.0
      command: ["kube-apiserver","--authorization-mode=RBAC,Node"]
      args: []
  restartPolicy: OnFailure

```

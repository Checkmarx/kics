---
title: Kubelet Certificate Authority Not Set
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

-   **Query id:** ec18a0d3-0069-4a58-a7fb-fbfe0b4bbbe0
-   **Query name:** Kubelet Certificate Authority Not Set
-   **Platform:** Kubernetes
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Secret Management
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/295.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/295.html')">295</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/k8s/kubelet_certificate_authority_not_set)

### Description
When using kube-apiserver command, the 'kubelet-certificate-authority' flag should be set<br>
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
      args: ["--kubelet-certificate-authority=/path/to/any/cert/file.pem"]
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
      command: ["kube-apiserver","--kubelet-certificate-authority=/path/to/any/cert/file.crt"]
      args: []
  restartPolicy: OnFailure

```

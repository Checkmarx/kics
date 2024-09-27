---
title: Pod Security Policy Admission Control Plugin Not Set
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

-   **Query id:** afa36afb-39fe-4d94-b9b6-afb236f7a03d
-   **Query name:** Pod Security Policy Admission Control Plugin Not Set
-   **Platform:** Kubernetes
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Build Process
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/284.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/284.html')">284</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/k8s/pod_security_policy_admission_control_plugin_not_set)

### Description
When using kube-apiserver command, the '--enable-admission-plugins' flag should have 'PodSecurityPolicy' plugin and the plugin should be correctly configured in AdmissionControl Config file<br>
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
      args: ["--enable-admission-plugins=AlwaysAdmit"]
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
      args: ["--enable-admission-plugins=PodSecurityPolicy", "--admission-control-config-file=path/to/plugin/config/file.yaml"]
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
      command: ["kube-apiserver","--enable-admission-plugins=PodSecurityPolicy", "--admission-control-config-file=path/to/plugin/config/file.yaml"]
      args: []
  restartPolicy: OnFailure

```

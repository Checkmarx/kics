---
title: CloudWatch Without Retention Period Specified
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

-   **Query id:** 934613fe-b12c-4e5a-95f5-c1dcdffac1ff
-   **Query name:** CloudWatch Without Retention Period Specified
-   **Platform:** Crossplane
-   **Severity:** <span style="color:#5bc0de">Info</span>
-   **Category:** Observability
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/778.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/778.html')">778</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/crossplane/aws/cloudwatch_without_retention_period_specified)

### Description
AWS CloudWatch should have CloudWatch Logs enabled in order to monitor, store, and access log events<br>
[Documentation](https://doc.crds.dev/github.com/crossplane/provider-aws/cloudwatchlogs.aws.crossplane.io/LogGroup/v1alpha1@v0.29.0#spec-forProvider-retentionInDays)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="9 38"
apiVersion: cloudwatchlogs.aws.crossplane.io/v1alpha1
kind: LogGroup
metadata:
  name: lg-3
spec:
  forProvider:
    logGroupName: /aws/eks/sample-cluster/cluster
    region: us-east-1
    retentionInDays: 0
---
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: cluster-aws
  labels:
    provider: aws
    cluster: eks
spec:
  compositeTypeRef:
    apiVersion: mydev.org/v1alpha1
    kind: CompositeCluster
  writeConnectionSecretsToNamespace: crossplane-system
  patchSets:
    - name: metadata
      patches:
        - fromFieldPath: metadata.labels
  resources:
    - name: sample-ec2
      base:
        apiVersion: cloudwatchlogs.aws.crossplane.io/v1alpha1
        kind: LogGroup
        metadata:
          name: lg-4
        spec:
          forProvider:
            logGroupName: /aws/eks/sample-cluster/cluster
            region: us-east-1
            retentionInDays: 0

```
```yaml title="Positive test num. 2 - yaml file" hl_lines="34 6"
apiVersion: cloudwatchlogs.aws.crossplane.io/v1alpha1
kind: LogGroup
metadata:
  name: lg-5
spec:
  forProvider:
    logGroupName: /aws/eks/sample-cluster/cluster
    region: us-east-1
---
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: cluster-aws
  labels:
    provider: aws
    cluster: eks
spec:
  compositeTypeRef:
    apiVersion: mydev.org/v1alpha1
    kind: CompositeCluster
  writeConnectionSecretsToNamespace: crossplane-system
  patchSets:
    - name: metadata
      patches:
        - fromFieldPath: metadata.labels
  resources:
    - name: sample-ec2
      base:
        apiVersion: cloudwatchlogs.aws.crossplane.io/v1alpha1
        kind: LogGroup
        metadata:
          name: lg-6
        spec:
          forProvider:
            logGroupName: /aws/eks/sample-cluster/cluster
            region: us-east-1

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
apiVersion: cloudwatchlogs.aws.crossplane.io/v1alpha1
kind: LogGroup
metadata:
  name: lg-1
spec:
  forProvider:
    logGroupName: /aws/eks/sample-cluster/cluster
    region: us-east-1
    retentionInDays: 1
---
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: cluster-aws
  labels:
    provider: aws
    cluster: eks
spec:
  compositeTypeRef:
    apiVersion: mydev.org/v1alpha1
    kind: CompositeCluster
  writeConnectionSecretsToNamespace: crossplane-system
  patchSets:
    - name: metadata
      patches:
        - fromFieldPath: metadata.labels
  resources:
    - name: sample-ec2
      base:
        apiVersion: cloudwatchlogs.aws.crossplane.io/v1alpha1
        kind: LogGroup
        metadata:
          name: lg-2
        spec:
          forProvider:
            logGroupName: /aws/eks/sample-cluster/cluster
            region: us-east-1
            retentionInDays: 1

```

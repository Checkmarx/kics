---
title: Cloud Storage Bucket Logging Not Enabled
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

-   **Query id:** 6c2d627c-de0f-45fb-b33d-dad9bffbb421
-   **Query name:** Cloud Storage Bucket Logging Not Enabled
-   **Platform:** Crossplane
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Observability
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/778.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/778.html')">778</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/crossplane/gcp/cloud_storage_bucket_logging_not_enabled)

### Description
Cloud storage bucket should have logging enabled<br>
[Documentation](https://doc.crds.dev/github.com/crossplane/provider-gcp/storage.gcp.crossplane.io/Bucket/v1alpha3@v0.21.0#spec-logging)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="5"
apiVersion: storage.gcp.crossplane.io/v1alpha3
kind: Bucket
metadata:
  name: bucketSample
spec:
  location: EU
  storageClass: MULTI_REGIONAL
  providerConfigRef:
    name: crossplane-gcp
  labels:
    made-by: crossplane
  deletionPolicy: Delete

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
apiVersion: storage.gcp.crossplane.io/v1alpha3
kind: Bucket
metadata:
  name: bucketSample
spec:
  location: EU
  logging:
    logBucket: example-logs-bucket
  storageClass: MULTI_REGIONAL
  providerConfigRef:
    name: crossplane-gcp
  labels:
    made-by: crossplane
  deletionPolicy: Delete

```

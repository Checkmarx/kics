---
title: Cloud Storage Bucket Is Publicly Accessible
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

-   **Query id:** 77c1fa3f-83dc-4c9d-bfed-e1d0cc8fd9dc
-   **Query name:** Cloud Storage Bucket Is Publicly Accessible
-   **Platform:** GoogleDeploymentManager
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Access Control
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/1188.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/1188.html')">1188</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/googleDeploymentManager/gcp/cloud_storage_bucket_is_publicly_accessible)

### Description
Cloud Storage Bucket is anonymously or publicly accessible<br>
[Documentation](https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="5"
resources:
  - name: bucket-access-control
    type: storage.v1.bucketAccessControl
    properties:
      entity: allUsers

```
```yaml title="Positive test num. 2 - yaml file" hl_lines="5"
resources:
  - name: bucket-access-control
    type: storage.v1.bucketAccessControl
    properties:
      entity: allAuthenticatedUsers

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
resources:
  - name: bucket-access-control
    type: storage.v1.bucketAccessControl
    properties:
      storageClass: STANDARD
      location: EUROPE-WEST3

```
```yaml title="Negative test num. 2 - yaml file"
resources:
  - name: bucket-access-control
    type: storage.v1.bucketAccessControl
    properties:
      storageClass: STANDARD
      location: EUROPE-WEST3
      entity: user-liz@example.com

```

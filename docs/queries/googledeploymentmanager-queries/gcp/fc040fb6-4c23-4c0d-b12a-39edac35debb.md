---
title: Disk Encryption Disabled
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

-   **Query id:** fc040fb6-4c23-4c0d-b12a-39edac35debb
-   **Query name:** Disk Encryption Disabled
-   **Platform:** GoogleDeploymentManager
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Encryption
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/326.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/326.html')">326</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/googleDeploymentManager/gcp/disk_encryption_disabled)

### Description
VM disks for critical VMs must be encrypted with Customer Supplied Encryption Keys (CSEK) or with Customer-managed encryption keys (CMEK), which means the attribute 'diskEncryptionKey' must be defined and its sub attributes 'rawKey' or 'kmsKeyName' must also be defined<br>
[Documentation](https://cloud.google.com/compute/docs/reference/rest/v1/instances)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="8 18"
resources:
- name: vm-template
  type: compute.v1.instance
  properties:
    zone: us-central1-a
    machineType: zones/us-central1-a/machineTypes/n1-standard-1
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: projects/debian-cloud/global/images/family/debian-9
    networkInterfaces:
    - network: global/networks/default
- type: compute.v1.disk
  name: disk-3-data
  properties:
    sizeGb: 10
    zone: us-east1-c

```
```yaml title="Positive test num. 2 - yaml file" hl_lines="14 23"
resources:
- name: vm-template2
  type: compute.v1.instance
  properties:
    zone: us-central1-a
    machineType: zones/us-central1-a/machineTypes/n1-standard-1
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: projects/debian-cloud/global/images/family/debian-9
      diskEncryptionKey:
        sha_256: 68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29
    networkInterfaces:
    - network: global/networks/default
- type: compute.v1.disk
  name: disk-4-data
  properties:
    sizeGb: 10
    zone: us-east1-c
    diskEncryptionKey:
      sha_256: 68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29

```
```yaml title="Positive test num. 3 - yaml file" hl_lines="16 26"
resources:
- name: vm-template3
  type: compute.v1.instance
  properties:
    zone: us-central1-a
    machineType: zones/us-central1-a/machineTypes/n1-standard-1
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: projects/debian-cloud/global/images/family/debian-9
      diskEncryptionKey:
        sha_256: 68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29
        rawKey: ""
    networkInterfaces:
    - network: global/networks/default
- type: compute.v1.disk
  name: disk-5-data
  properties:
    sizeGb: 10
    zone: us-east1-c
    diskEncryptionKey:
      sha_256: 68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29
      rawKey: ""

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
resources:
- name: vm-template4
  type: compute.v1.instance
  properties:
    zone: us-central1-a
    machineType: zones/us-central1-a/machineTypes/n1-standard-1
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: projects/debian-cloud/global/images/family/debian-9
      diskEncryptionKey:
        sha_256: 68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29
        rawKey: SGVsbG8gZnJvbSBHb29nbGUgQ2xvdWQgUGxhdGZvcm0=
    networkInterfaces:
    - network: global/networks/default
- type: compute.v1.disk
  name: disk-1-data
  properties:
    sizeGb: 10
    zone: us-east1-c
    diskEncryptionKey:
      sha_256: 68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29
      rawKey: SGVsbG8gZnJvbSBHb29nbGUgQ2xvdWQgUGxhdGZvcm0=


```
```yaml title="Negative test num. 2 - yaml file"
resources:
- name: vm-template5
  type: compute.v1.instance
  properties:
    zone: us-central1-a
    machineType: zones/us-central1-a/machineTypes/n1-standard-1
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: projects/debian-cloud/global/images/family/debian-9
      diskEncryptionKey:
        sha_256: 68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29
        kmsKeyName: disk-crypto-key
    networkInterfaces:
    - network: global/networks/default
- type: compute.v1.disk
  name: disk-2-data
  properties:
    sizeGb: 10
    zone: us-east1-c
    diskEncryptionKey:
      sha_256: 68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29
      kmsKeyName: disk-crypto-key

```

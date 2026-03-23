# KICS Rule: GKE Secrets Not Encrypted with CMEK

## Overview

This **HIGH** severity rule verifies that GKE clusters have application-layer secret encryption enabled using a customer-managed **Cloud KMS** key (**CMEK**).

By default, GKE encrypts data at rest at the disk level, but Kubernetes secrets stored in the `etcd` database require an additional layer of protection. By enabling this feature, GKE uses envelope encryption where a Data Encryption Key (DEK) encrypts the secret, and that DEK is encrypted by a Key Encryption Key (KEK) hosted in Cloud KMS. This allows the customer to have absolute sovereignty over their secrets, being able to revoke access to them instantly by disabling the key in KMS.

## Rule Logic

The policy audits the `google_container_cluster` resource by evaluating three security failures:
1.  **Omission:** The `database_encryption` block is not defined.
2.  **Disabling:** The encryption state is explicitly set to `DECRYPTED`.
3.  **Incomplete Configuration:** Encryption is activated but the key identifier (`key_name`) is not provided.

## Detected Failure Cases

---

### Case 1: Missing Encryption Configuration
* **Description:** The cluster is provisioned without the protection layer for secrets in etcd.
* **Alert Location:** `google_container_cluster` resource block.

### Case 2: Encryption Disabled
* **Description:** The block is configured but the state is marked as unencrypted.
* **Alert Location:** `state` attribute within `database_encryption`.

### Case 3: Missing KMS Key
* **Description:** Encryption is attempted but no valid Cloud KMS key is referenced.
* **Alert Location:** `key_name` attribute within `database_encryption`.

## Resource Involved

* `google_container_cluster`

## Solution

Configure the `database_encryption` block with the `ENCRYPTED` state and assign the corresponding key resource.

```terraform
resource "google_container_cluster" "secure_cluster" {
  name     = "production-cluster"
  location = "us-central1"

  # Technical solution
  database_encryption {
    state    = "ENCRYPTED"
    key_name = "projects/my-project/locations/global/keyRings/my-ring/cryptoKeys/my-key"
  }
}

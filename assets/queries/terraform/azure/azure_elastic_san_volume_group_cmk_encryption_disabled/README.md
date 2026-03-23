# KICS Rule: Elastic SAN Volume Group CMK Encryption Disabled

## General Description

This KICS rule verifies that Azure Elastic SAN volume groups (`azurerm_elastic_san_volume_group`) are configured to use Customer-Managed Keys (CMK) for data encryption at rest.

Using CMK over default platform-managed keys is a critical security practice. It provides organizations with full control over the lifecycle of cryptographic keys, including access policies, rotation, and revocation. This is essential for meeting regulatory requirements and ensuring that data stored in the SAN is protected by keys under the direct control of the customer.

## Rule Logic

The policy analyzes the `azurerm_elastic_san_volume_group` resource by validating two fundamental pillars:
1.  **Type Configuration:** The `encryption_type` attribute must be unambiguously set to `EncryptionAtRestWithCustomerManagedKey`.
2.  **Supporting Infrastructure:** If CMK is selected, the resource must mandatorily include both the `encryption` block (which links the key) and the `identity` block (which grants access to it).

## Detected Failure Cases

The following describes the scenarios this policy will detect.

---
### Case 1: CMK Encryption Not Configured (Platform Key Usage)

* **Description:** The resource lacks the CMK encryption attribute or uses the default platform-managed value.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_elastic_san_volume_group" "fail_platform" {
      name           = "example-vg"
      elastic_san_id = azurerm_elastic_san.example.id
    }
    ```
* **Alert Location:** Root `azurerm_elastic_san_volume_group` resource.

---
### Case 2: CMK Selected with Missing Technical Blocks

* **Description:** The CMK encryption type has been activated, but one or both required blocks (`encryption` / `identity`) needed for the encryption to be operational are missing.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_elastic_san_volume_group" "fail_missing_blocks" {
      encryption_type = "EncryptionAtRestWithCustomerManagedKey"
      # Missing encryption block or identity block
    }
    ```
* **Alert Location:** Root `azurerm_elastic_san_volume_group` resource.

## Involved Resource

* `azurerm_elastic_san_volume_group`

## Solution

To fix the issue, make sure to declare the CMK encryption type and include the required technical blocks with their mandatory parameters.

```terraform
resource "azurerm_elastic_san_volume_group" "secure_vg" {
  name           = "secure-volume-group"
  elastic_san_id = azurerm_elastic_san.example.id

  encryption_type = "EncryptionAtRestWithCustomerManagedKey"

  encryption {
    key_vault_key_id = azurerm_key_vault_key.example.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }
}

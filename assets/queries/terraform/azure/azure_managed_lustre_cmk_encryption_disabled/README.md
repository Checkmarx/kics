# KICS Rule: Azure Managed Lustre Not Encrypted with CMK

## General Description

This KICS rule verifies that **Azure Managed Lustre** file systems (`azurerm_managed_lustre_file_system`) are configured to use **Customer-Managed Keys (CMK)** for data encryption at rest.

By default, Azure encrypts data in Lustre using platform-managed keys. To meet data sovereignty and governance requirements, the use of CMK via the `encryption_key` block is recommended. This gives organizations full control over the key lifecycle, allowing rotation and selective revocation of access to the high-performance data stored in the file system.

## Rule Logic

The policy analyzes the `azurerm_managed_lustre_file_system` resource by validating the following condition:
1.  **Encryption Block Presence:** The existence of the `encryption_key` block is verified. If this block is not defined, the file system defaults to Azure-managed encryption.

## Detected Failure Case

The following describes the scenario this policy will detect.

---

### Single Case: Use of Platform-Managed Keys (Block Absent)

* **Description:** The Lustre file system is defined without the customer encryption configuration block, delegating data protection to the platform's default keys.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_managed_lustre_file_system" "example_insecure" {
      name                   = "insecure-lustre"
      resource_group_name    = "rg-example"
      location               = "West Europe"
      sku_name               = "AMLFS-Durable-Premium-250"
      subnet_id              = azurerm_subnet.example.id
      storage_capacity_in_tb = 48

      # The resource lacks the encryption_key block
    }
    ```
* **Alert Location:** On the root `azurerm_managed_lustre_file_system` resource.

## Involved Resource

* `azurerm_managed_lustre_file_system`

## Solution

To fix this risk, define the `encryption_key` block providing the key URL and the source Key Vault ID.

```terraform
resource "azurerm_managed_lustre_file_system" "secure_lustre" {
  name                   = "secure-lustre"
  resource_group_name    = "rg-example"
  location               = "West Europe"
  sku_name               = "AMLFS-Durable-Premium-250"
  subnet_id              = azurerm_subnet.example.id
  storage_capacity_in_tb = 48

  # SOLUTION: Configure encryption with CMK
  encryption_key {
    key_url         = azurerm_key_vault_key.example.id
    source_vault_id = azurerm_key_vault.example.id
  }
}

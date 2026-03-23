# KICS Rule: Recovery Services Vault CMK Encryption Disabled

## General Description

This KICS rule verifies that **Recovery Services Vault** vaults (used for Azure Backup and Azure Site Recovery) are configured to use **Customer-Managed Keys (CMK)** for data encryption at rest.

By default, backed-up data is encrypted using Microsoft platform-managed keys. However, to comply with regulatory requirements and ensure data sovereignty, organizations must use their own keys stored in Azure Key Vault. This allows full control over key rotation, access policies, and the ability to revoke access to backup data when needed.

## Rule Logic

The policy analyzes the `azurerm_recovery_services_vault` resource by validating the following technical condition:
1.  **Presence of the Encryption Block:** The existence of the `encryption` block is checked. The absence of this block implies that the vault uses the default platform-managed encryption, which does not meet CMK requirements.

## Detected Failure Case

The following describes the scenario that this policy will detect.

---

### Single Case: Use of Platform Keys (Default Encryption)

* **Description:** The Recovery Services Vault is defined without the customer encryption configuration block, delegating data protection to Azure's automatic keys.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_recovery_services_vault" "fail_vault" {
      name                = "insecure-vault"
      location            = "West Europe"
      resource_group_name = "rg-production"
      sku                 = "Standard"

      # The resource lacks the encryption {} block
    }
    ```
* **Alert Location:** On the root `azurerm_recovery_services_vault` resource.

## Involved Resource

* `azurerm_recovery_services_vault`

## Solution

To resolve this finding, you must enable a managed identity on the Vault and configure the `encryption` block by mandatorily providing the `key_id` from Azure Key Vault.

```terraform
resource "azurerm_recovery_services_vault" "secure_vault" {
  name                = "secure-recovery-vault"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"

  # 1. Enable identity for Key Vault access
  identity {
    type = "SystemAssigned"
  }

  # 2. Configure CMK encryption (key_id is required in this block)
  encryption {
    key_id                       = azurerm_key_vault_key.example.id
    use_system_assigned_identity = true
  }
}

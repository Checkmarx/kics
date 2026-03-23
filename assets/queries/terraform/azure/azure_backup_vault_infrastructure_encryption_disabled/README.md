# KICS Rule: Backup Vault Infrastructure Encryption Disabled

## General Description

This rule verifies readiness for advanced encryption in Azure backup vaults (**Data Protection Backup Vaults**).

For a Backup Vault to support additional or customer-managed (CMK) encryption layers, the resource must have an assigned identity (`identity`). Without an identity, the vault can only use the platform's default encryption.

## Rule Logic

The policy audits the `azurerm_data_protection_backup_vault` resource:
1.  Verifies the existence of the `identity` block.
2.  If the block is absent, the resource is considered not ready for infrastructure or customer-managed encryption configurations.

## Detected Failure Cases

### Case 1: Identity Not Configured

* **Description:** The Backup Vault does not have an identity (SystemAssigned or UserAssigned), which prevents linking to external encryption keys.
* **Alert Location:** Resource level `azurerm_data_protection_backup_vault`.

## Involved Resource

* `azurerm_data_protection_backup_vault`

## Solution

Add an `identity` block to the resource.

```terraform
resource "azurerm_data_protection_backup_vault" "example" {
  name                = "vault-secure"
  resource_group_name = "rg-example"
  location            = "West Europe"
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  # Technical solution to enable encryption capabilities
  identity {
    type = "SystemAssigned"
  }
}

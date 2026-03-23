# KICS Rule: Backup Vault CMK Encryption Disabled

## General Description

This rule verifies that Azure backup vaults (**Backup Vaults** from the Data Protection service) are encrypted using **Customer-Managed Keys (CMK)**.

Using customer-managed keys provides full control over the key lifecycle (creation, rotation, and revocation) and is a common requirement in environments with high security and compliance demands. In Terraform, this is configured through a separate resource (`azurerm_data_protection_backup_vault_customer_managed_key`) that links the Vault to the key stored in a Key Vault.

## Rule Logic

The policy performs a relationship analysis between resources:
1.  Identifies all `azurerm_data_protection_backup_vault` resources.
2.  Searches for an `azurerm_data_protection_backup_vault_customer_managed_key` resource whose `data_protection_backup_vault_id` property points to the analyzed Vault.
3.  Verifies that this association resource has the `key_vault_key_id` attribute defined.
4.  If this linkage does not exist, an alert is generated indicating that the Vault uses platform-managed keys (default configuration).

## Detected Failure Cases

### Case 1: Backup Vault Without CMK

* **Description:** The Backup Vault is defined but the customer-managed encryption key association resource is not found.
* **Alert Location:** On the `azurerm_data_protection_backup_vault` resource.

## Involved Resource

* `azurerm_data_protection_backup_vault`
* `azurerm_data_protection_backup_vault_customer_managed_key`

## Solution

Define the `azurerm_data_protection_backup_vault_customer_managed_key` association resource and link it to the Vault and the corresponding Key.

```terraform
resource "azurerm_data_protection_backup_vault_customer_managed_key" "example" {
  data_protection_backup_vault_id = azurerm_data_protection_backup_vault.example.id
  key_vault_key_id                = azurerm_key_vault_key.example.id
}

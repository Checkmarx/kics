# KICS Rule: Backup Vault Cross Region Restore Disabled

## General Description

This rule verifies that the **Cross Region Restore** functionality (`cross_region_restore_enabled`) is enabled on `azurerm_data_protection_backup_vault` resources.

Cross Region Restore (CRR) allows backup data to be restored in a secondary paired Azure region (Azure Paired Region). This is essential to ensure business continuity and data recovery in the event that the primary region suffers a total outage or geographic disaster.

**Note:** To use CRR effectively, the vault requires redundancy to be configured as `GeoRedundant`.

## Rule Logic

The policy evaluates the `azurerm_data_protection_backup_vault` resource under two scenarios:
1.  **Missing Attribute:** If `cross_region_restore_enabled` is not explicitly defined, an alert is generated on the resource (since the default value on the platform is usually false).
2.  **Explicitly Disabled:** If the attribute is set to `false`, the alert points directly to the line of the incorrect configuration.

## Detected Failure Cases

---

### Case 1: Missing Configuration
* **Description:** The Backup Vault is defined without specifying the cross-region restore policy, leaving data vulnerable to regional failures.
* **Alert Location:** Resource level `azurerm_data_protection_backup_vault`.

### Case 2: CRR Disabled
* **Description:** The `cross_region_restore_enabled` attribute is explicitly configured as `false`.
* **Alert Location:** Line `cross_region_restore_enabled`.

## Involved Resource

* `azurerm_data_protection_backup_vault`

## Solution

Set the `cross_region_restore_enabled` attribute to `true`. It is highly recommended to verify that the redundancy type (`redundancy`) is configured as `GeoRedundant`.

```terraform
resource "azurerm_data_protection_backup_vault" "example_secure" {
  name                         = "vault-secure"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  datastore_type               = "VaultStore"
  redundancy                   = "GeoRedundant"

  # Technical solution
  cross_region_restore_enabled = true
}

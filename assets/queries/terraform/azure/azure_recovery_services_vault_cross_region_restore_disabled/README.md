# KICS Rule: Recovery Services Vault Cross Region Restore Disabled

## General Description

This KICS rule verifies that the **Cross Region Restore** functionality (`cross_region_restore_enabled`) is enabled in **Recovery Services Vault** vaults.

Enabling Cross Region Restore (CRR) is a critical component of a business continuity and disaster recovery strategy (DRP). This feature allows data restores to be performed in a secondary paired Azure region at any time, ensuring access to backups even if the primary region suffers a total outage or regional disaster.

**Technical note:** For cross-region restore to be effective, the vault must have its storage type configured as `GeoRedundant`.

## Rule Logic

The policy analyzes the `azurerm_recovery_services_vault` resource by evaluating two conditions:
1.  **Missing Attribute:** If `cross_region_restore_enabled` is not explicitly defined, it is considered non-compliant, since the default configuration does not guarantee data availability in the secondary region.
2.  **Incorrect Configuration:** If the attribute is explicitly set to `false`, an alert is generated indicating the lack of operational redundancy for restores.

## Detected Failure Cases

The following describes the scenarios that this policy will detect.

---

### Case 1: Missing CRR Configuration

* **Description:** The vault is defined without specifying the regional restore policy, resulting in the default deactivation of this resilience measure.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_recovery_services_vault" "fail_missing" {
      name                = "vault-insecure"
      location            = "West Europe"
      resource_group_name = azurerm_resource_group.example.name
      sku                 = "Standard"
      storage_mode_type   = "GeoRedundant"
      # Missing cross_region_restore_enabled = true
    }
    ```
* **Alert Location:** On the root `azurerm_recovery_services_vault` resource.

---

### Case 2: CRR Explicitly Disabled

* **Description:** The `cross_region_restore_enabled` attribute has been configured with the value `false`, preventing disaster recovery in paired regions.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_recovery_services_vault" "fail_false" {
      name                         = "vault-disabled"
      storage_mode_type            = "GeoRedundant"
      cross_region_restore_enabled = false # <-- Detected issue
    }
    ```
* **Alert Location:** `cross_region_restore_enabled` attribute.

## Involved Resource

* `azurerm_recovery_services_vault`

## Solution

Set `cross_region_restore_enabled` to `true` and ensure that `storage_mode_type` is `GeoRedundant`.

```terraform
resource "azurerm_recovery_services_vault" "secure_vault" {
  name                         = "vault-resilient"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  sku                          = "Standard"
  storage_mode_type            = "GeoRedundant"

  # SOLUTION: Enable cross-region restore
  cross_region_restore_enabled = true
}

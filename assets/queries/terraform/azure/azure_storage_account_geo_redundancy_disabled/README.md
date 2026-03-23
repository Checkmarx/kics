# KICS Rule: Storage Account Geo-Redundancy Disabled

## General Description

This KICS rule verifies that Azure storage accounts (`azurerm_storage_account`) are configured with **Geo-Redundancy**.

Geo-redundancy is a fundamental business continuity strategy. By enabling it, Azure asynchronously copies data to a secondary region located hundreds of kilometers from the primary region. This ensures that, in the event of a catastrophic regional disaster (massive network failures, natural disasters, or region-wide power outages), data remains durable and available for recovery, minimizing RPO (Recovery Point Objective) and RTO (Recovery Time Objective).

## Rule Logic

The policy audits the `account_replication_type` attribute of the `azurerm_storage_account` resource:
1.  **Type Validation:** Checks whether the configured value belongs to the high regional availability group: `GRS`, `RAGRS`, `GZRS`, or `RAGZRS`.
2.  **Risk Detection:** If the value is `LRS` (Locally Redundant) or `ZRS` (Zone Redundant), an alert is generated, as these levels only protect against hardware failures within a datacenter or zone, but not against the loss of an entire region.

## Detected Failure Case

The following describes the scenario that this policy will detect.

---

### Single Case: Local or Zonal Replication (LRS/ZRS)

* **Description:** The storage account uses a replication scheme that does not extend beyond the primary region, leaving data vulnerable to regional disasters.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_storage_account" "fail_storage" {
      name                     = "insecurestorage"
      resource_group_name      = azurerm_resource_group.example.name
      location                 = azurerm_resource_group.example.location
      account_tier             = "Standard"

      # FAILURE: Replication limited to the local region
      account_replication_type = "LRS"
    }
    ```
* **Alert Location:** `account_replication_type` attribute.

## Involved Resource

* `azurerm_storage_account`

## Solution

To mitigate this risk in production environments, change the replication type to one that supports geo-redundancy, such as **GRS**.

```terraform
resource "azurerm_storage_account" "secure_storage" {
  name                     = "securestorage"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"

  # SOLUTION: Enable geo-redundancy
  account_replication_type = "GRS"
}

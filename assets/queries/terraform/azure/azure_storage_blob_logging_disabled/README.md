# KICS Rule: Storage Blob Service Logging Disabled

## General Description

This rule verifies that diagnostic logging (**Diagnostic Settings**) is enabled and fully configured for the **Blob** service in Azure storage accounts.

To ensure complete data plane auditing, it is imperative to log the three fundamental operations that allow tracking the lifecycle of objects:
* **StorageRead:** Audit of blob data reads and container metadata.
* **StorageWrite:** Audit of blob uploads, creations, and modifications.
* **StorageDelete:** Audit of object and container deletions.

## Rule Logic

The policy audits the Terraform code by evaluating three compliance levels:
1.  **Resource Existence:** Verifies that each `azurerm_storage_account` has an `azurerm_monitor_diagnostic_setting` resource linked to its blob endpoint (`/blobServices/default`).
2.  **Log Presence:** Alerts if the diagnostic resource exists but contains no log definitions (`enabled_log`).
3.  **Category Integrity:** Analyzes that the `StorageRead`, `StorageWrite`, and `StorageDelete` categories are all present. If the set is incomplete, the alert points directly to the `enabled_log` block.

## Detected Failure Cases

### Case 1: Blob Service Without Diagnostic Settings
* **Location:** `azurerm_storage_account`.

### Case 2: Diagnostic Setting Without Log Blocks
* **Location:** `azurerm_monitor_diagnostic_setting`.

### Case 3: Incomplete Blob Audit
* **Description:** The log block does not contain the complete set of categories (Read, Write, and Delete).
* **Location:** `enabled_log` block within `azurerm_monitor_diagnostic_setting`.

## Involved Resources
* `azurerm_storage_account`
* `azurerm_monitor_diagnostic_setting`

## Solution

```terraform
resource "azurerm_monitor_diagnostic_setting" "secure_blob_logging" {
  name               = "blob-audit-complete"
  target_resource_id = "${azurerm_storage_account.example.id}/blobServices/default"
  storage_account_id = azurerm_storage_account.log_destination.id

  enabled_log { category = "StorageRead" }
  enabled_log { category = "StorageWrite" }
  enabled_log { category = "StorageDelete" }
}

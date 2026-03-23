# KICS Rule: Storage Table Service Logging Disabled

## General Description

This rule verifies that diagnostic logging (**Diagnostic Settings**) is enabled and fully configured for the **Table Service** in Azure storage accounts.

Auditing Azure Storage NoSQL tables allows capturing telemetry on who accesses and modifies stored data. The policy ensures that the three essential operation categories are captured for complete traceability:
* **StorageRead:** Audit of entity queries and table metadata reads.
* **StorageWrite:** Audit of data insertions, updates, and upserts.
* **StorageDelete:** Audit of entity deletions or table structure deletions.

Without these active logs, organizations lack the telemetry needed to identify unauthorized access to sensitive data or investigate errors in NoSQL record manipulation.

## Rule Logic

The policy audits the Terraform code by evaluating three compliance levels:
1.  **Resource Existence:** Verifies that each `azurerm_storage_account` has an `azurerm_monitor_diagnostic_setting` resource linked to its table endpoint (`/tableServices/default`).
2.  **Log Presence:** Alerts if the diagnostic resource exists but the `enabled_log` block is absent.
3.  **Category Integrity:** Analyzes that the `StorageRead`, `StorageWrite`, and `StorageDelete` categories are all present simultaneously. If the set is incomplete, the alert points directly to the `enabled_log` block.

## Detected Failure Cases

### Case 1: Table Service Without Diagnostic Settings
* **Description:** The storage account has no logging destination configured for tables.
* **Location:** `azurerm_storage_account`.

### Case 2: Diagnostic Setting Without Log Blocks
* **Description:** The diagnostic resource exists but the log configuration is empty.
* **Location:** `azurerm_monitor_diagnostic_setting`.

### Case 3: Incomplete Table Audit
* **Description:** One or more critical categories are missing from the log configuration.
* **Location:** `enabled_log` block within `azurerm_monitor_diagnostic_setting`.

## Involved Resources
* `azurerm_storage_account`
* `azurerm_monitor_diagnostic_setting`

## Solution

Configure a complete Diagnostic Setting for the table service.

```terraform
resource "azurerm_monitor_diagnostic_setting" "secure_table_logging" {
  name               = "table-audit-complete"
  target_resource_id = "${azurerm_storage_account.example.id}/tableServices/default"
  storage_account_id = azurerm_storage_account.logs.id

  enabled_log { category = "StorageRead" }
  enabled_log { category = "StorageWrite" }
  enabled_log { category = "StorageDelete" }
}

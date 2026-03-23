# KICS Rule: MySQL Audit Log Enabled (Manual)

## General Description

This KICS rule acts as a manual control to ensure that the server parameter `audit_log_enabled` is set to `ON` in **Azure Database for MySQL** instances.

Audit logs are essential for database observability and security. They allow tracking of specific events, such as connection attempts, DDL query execution, and user privilege changes. Because in Azure MySQL these parameters can be managed externally to the server resource (either through the portal or via independent configuration resources), manual validation is required to confirm compliance.

## Rule Logic

Since the audit configuration does not necessarily reside within the main MySQL server block in Terraform, the static analysis focuses on:
1.  **Resource Identification:** The rule locates all resources of type `azurerm_mssql_server` and `azurerm_mysql_flexible_server`.
2.  **Audit Reminder:** Generates an informational severity finding to alert the administrator of the need to verify the status of the `audit_log_enabled` parameter.

## Detected Failure Case

The following describes the scenario this policy will detect.

---

### Single Case: Manual Verification Required

* **Description:** The presence of a MySQL server is detected. Since the audit status is not always statically verifiable from the server resource, a manual review is requested.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_mssql_server" "example_insecure" {
      name                = "mysql-server-audit-check"
      resource_group_name = azurerm_resource_group.example.name
      location            = azurerm_resource_group.example.location
      # The status of audit_log_enabled is not visible here.
    }
    ```
* **Alert Location:** On the detected MySQL server resource.

## Involved Resource

* `azurerm_mssql_server`
* `azurerm_mysql_flexible_server`

## Solution

There are two methods to ensure that auditing is enabled:

### Option A: Manual Verification (Azure Portal)
1. Navigate to your MySQL server in the Azure Portal.
2. Go to the **Server parameters** section.
3. Search for the `audit_log_enabled` parameter and confirm its value is `ON`.

### Option B: Configuration as Code (Recommended)
Use the `azurerm_mysql_configuration` resource (for Single Server) or `azurerm_mysql_flexible_server_configuration` (for Flexible Server) to enforce the parameter:

```terraform
# Example for MySQL Single Server
resource "azurerm_mysql_configuration" "audit_log" {
  name                = "audit_log_enabled"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mssql_server.example.name
  value               = "ON"
}

# KICS Rule: MySQL Audit Log Events Connection (Manual)

## General Description

This KICS rule acts as a manual control to verify that the server parameter `audit_log_events` includes the value `CONNECTION` in **Azure Database for MySQL** servers.

Logging `CONNECTION` type events is a fundamental piece of the security and compliance strategy. It allows administrators and auditors to track who accesses the database, detect brute force attacks (failed attempts), and audit suspicious sessions. Without this configuration, visibility into initial access to data resources is lost, making incident response more difficult.

## Rule Logic

Because static analysis cannot always guarantee verification of a text string within an independent configuration resource (`azurerm_mysql_configuration`), this rule applies a preventive approach:
1.  **Resource Identification:** Detects all instances of `azurerm_mssql_server` and `azurerm_mysql_flexible_server`.
2.  **Security Reminder:** Generates an informational alert for the auditor to specifically verify that connection events are being captured.

## Detected Failure Case

The following describes the scenario this policy will detect.

---

### Single Case: Manual Verification Required

* **Description:** A provisioned MySQL server is detected. KICS issues an alert to ensure that the audited event types include connections, since this configuration may be delegated to other resources or the portal.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_mssql_server" "example_audit_check" {
      name                = "mysql-server-connection-check"
      resource_group_name = azurerm_resource_group.example.name
      location            = azurerm_resource_group.example.location
      # The content of audit_log_events is not verifiable here.
    }
    ```
* **Alert Location:** On the detected MySQL server resource.

## Involved Resource

* `azurerm_mssql_server`
* `azurerm_mysql_flexible_server`

## Solution

### Option A: Manual Verification (Azure Portal)
1. Navigate to the MySQL server in the Azure Portal.
2. Go to the **Server parameters** section.
3. Locate the `audit_log_events` parameter.
4. Ensure that `CONNECTION` is included among the selected values.

### Option B: Configuration via Terraform
Make sure to explicitly include the value in the configuration resource:

```terraform
resource "azurerm_mysql_configuration" "audit_events" {
  name                = "audit_log_events"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mssql_server.example.name

  # SOLUTION: Include CONNECTION in the list of events
  value               = "CONNECTION,QUERY,DDL"
}

# KICS Rule: App Service HTTP Logs Disabled

## General Description

This rule verifies that Azure App Service resources (`azurerm_linux_web_app` and `azurerm_windows_web_app`) have HTTP logs enabled.

HTTP logs record the web requests received by the application, including the requested URL, user agent, client IP address, and response status code. This information is essential for security auditing, regulatory compliance, and troubleshooting traffic issues.

## Rule Logic

The policy iterates over App Service resources and checks the configuration in two steps:
1.  **Absence of Logs:** Checks whether the `logs` block exists.
2.  **Absence of HTTP Logs:** If the `logs` block exists, checks that it contains the `http_logs` sub-block.

If HTTP logging is not explicitly enabled, an alert is generated.

## Detected Failure Cases

### Case 1: Missing Logs Configuration

* **Description:** The App Service resource is defined without specifying any `logs` configuration.
* **Alert Location:** Main resource level.

### Case 2: http_logs Block Omitted

* **Description:** The `logs` block is defined (e.g., for application logs), but HTTP traffic logs are omitted.
* **Alert Location:** `logs` block.

## Involved Resource

* `azurerm_linux_web_app`
* `azurerm_windows_web_app`

## Solution

Add the `logs` block and configure `http_logs` by defining a file system (`file_system`) or blob storage (`azure_blob_storage`).

```terraform
resource "azurerm_linux_web_app" "example_secure" {
  name                = "example-linux-web-app-secure"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}

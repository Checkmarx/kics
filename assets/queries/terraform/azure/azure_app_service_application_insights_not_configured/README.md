# KICS Rule: App Service Application Insights Not Configured

## General Description

This rule verifies that Azure App Service and Function Apps have **Application Insights** integration configured.

Application Insights is an Azure Monitor feature that provides application performance management (APM) and real-time error tracking. To link an App Service with Application Insights in Terraform, `APPLICATIONINSIGHTS_CONNECTION_STRING` (recommended) or `APPINSIGHTS_INSTRUMENTATIONKEY` must be defined within the `app_settings` block.

## Rule Logic

The policy iterates over `azurerm_linux_web_app`, `azurerm_windows_web_app`, `azurerm_linux_function_app`, and `azurerm_windows_function_app` resources.
It checks the configuration at two levels:
1.  **Absence of app_settings:** If the block is not defined.
2.  **Incomplete configuration:** If the block exists but does not contain the connection keys.

## Detected Failure Cases

### Case 1: Missing app_settings Configuration

* **Description:** The resource does not have the `app_settings` block defined.
* **Alert Location:** Main resource level.

### Case 2: App Insights Keys Missing

* **Description:** The `app_settings` block exists but does not contain `APPLICATIONINSIGHTS_CONNECTION_STRING` or `APPINSIGHTS_INSTRUMENTATIONKEY`.
* **Alert Location:** `app_settings` attribute.

## Involved Resource

* `azurerm_linux_web_app`
* `azurerm_windows_web_app`
* `azurerm_linux_function_app`
* `azurerm_windows_function_app`

## Solution

Define `APPLICATIONINSIGHTS_CONNECTION_STRING` within `app_settings`.

```terraform
resource "azurerm_linux_web_app" "example" {
  name                = "example-app"
  # ...
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.example.connection_string
  }
}

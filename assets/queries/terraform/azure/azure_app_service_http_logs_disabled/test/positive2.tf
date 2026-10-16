resource "azurerm_windows_web_app" "fail_incomplete_logs" {
  name                = "app-fail-2"
  resource_group_name = "rg"
  location            = "West Europe"
  service_plan_id     = "plan-id"

  logs {
    application_logs {
      file_system_level = "Information"
    }
    # Falta http_logs
  }
}
resource "azurerm_linux_web_app" "pass_app" {
  name                = "app-pass"
  resource_group_name = "rg"
  location            = "West Europe"
  service_plan_id     = "plan-id"

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}
resource "azurerm_linux_web_app" "fail_no_logs" {
  name                = "app-fail-1"
  resource_group_name = "rg"
  location            = "West Europe"
  service_plan_id     = "plan-id"

  site_config {}
}
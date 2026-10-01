resource "azurerm_linux_web_app" "fail_no_settings" {
  name                = "fail-app-no-settings"
  resource_group_name = "rg"
  location            = "West Europe"
  service_plan_id     = "plan-id"
}
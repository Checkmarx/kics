resource "azurerm_windows_web_app" "fail_incomplete_settings" {
  name                = "fail-app-incomplete"
  resource_group_name = "rg"
  location            = "West Europe"
  service_plan_id     = "plan-id"

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "14.15.0"
  }
}
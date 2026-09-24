resource "azurerm_linux_web_app" "fail" {
  name                = "my-web-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    remote_debugging_enabled = true
  }
}

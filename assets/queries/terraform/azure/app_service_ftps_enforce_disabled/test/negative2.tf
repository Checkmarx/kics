resource "azurerm_linux_web_app" "negative2" {
  name                = "negative2"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_app_service_plan.example.id

  site_config {
    ftps_state = "Disabled" # Options: AllAllowed, FtpsOnly, Disabled
  }
}

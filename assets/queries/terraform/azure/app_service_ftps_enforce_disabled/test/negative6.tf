resource "azurerm_windows_web_app" "negative6" {
  name                = "negative6"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    ftps_state = "FtpsOnly" # Options: AllAllowed, FtpsOnly, Disabled
  }
}
resource "azurerm_windows_web_app" "positive3" {
  name                = "positive3"
  location            = azurerm_service_plan.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    ftps_state = "AllAllowed" # Options: AllAllowed, FtpsOnly, Disabled
  }
}
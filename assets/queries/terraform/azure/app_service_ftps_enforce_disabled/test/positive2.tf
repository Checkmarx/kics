resource "azurerm_linux_web_app" "positive2" {
  name                = "positive2"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    ftps_state = "AllAllowed" # Options: AllAllowed, FtpsOnly, Disabled
  }
}
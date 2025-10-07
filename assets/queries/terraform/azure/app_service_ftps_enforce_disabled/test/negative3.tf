resource "azurerm_linux_web_app" "negative3" {
  name                = "negative3"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    ftps_state = "Disabled" # Options: AllAllowed, FtpsOnly, Disabled
  }
}
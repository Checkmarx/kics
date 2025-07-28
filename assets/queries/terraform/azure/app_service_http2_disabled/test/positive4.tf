resource "azurerm_linux_web_app" "positive4" {
  name                = "example-app-service"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    always_on = true
    ftps_state = "Disabled"
    minimum_tls_version = "1.2"
  }
}
resource "azurerm_windows_web_app" "negative4" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id
  auth_settings {
    enabled = true
  }
  site_config {}
}
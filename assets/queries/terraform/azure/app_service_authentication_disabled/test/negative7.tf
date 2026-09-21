resource "azurerm_linux_web_app" "negative7" {
  name                = "example-app-service"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id
  auth_settings {
    enabled = false
  }
  auth_settings_v2 {
    login {}
    auth_enabled = true
  }
  site_config {}
}
resource "azurerm_app_service_slot" "positive1" {
  name                = random_id.server.hex
  app_service_name    = azurerm_app_service.example.name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
}
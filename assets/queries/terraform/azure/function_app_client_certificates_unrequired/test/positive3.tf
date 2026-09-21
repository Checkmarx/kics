resource "azurerm_windows_function_app" "positive3-1" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id
}

resource "azurerm_windows_function_app" "positive3-2" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id

  client_certificate_mode = "Optional"
}

resource "azurerm_function_app" "negative1" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_linux_function_app" "negative2" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_windows_function_app" "negative3" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id
  identity {
    type = "SystemAssigned"
  }
}
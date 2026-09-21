resource "azurerm_app_service" "negative1-1" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_linux_web_app" "negative1-2" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_app_service_plan.example.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_windows_web_app" "negative1-3" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_app_service_plan.example.id

  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_linux_function_app" "negative2-1" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id

   site_config {
    ftps_state = "FtpsOnly"
  }
}

resource "azurerm_linux_function_app" "negative2-2" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id

   site_config {
    ftps_state = "Disabled"
  }
}

resource "azurerm_linux_function_app" "negative2-3" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id

   site_config {
    http2_enabled = true
  }
}

resource "azurerm_linux_function_app" "negative2-4" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id
}


resource "azurerm_windows_function_app" "negative3-1" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id

   site_config {
    ftps_state = "FtpsOnly"
  }
}

resource "azurerm_windows_function_app" "negative3-2" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id

   site_config {
    ftps_state = "Disabled"
  }
}

resource "azurerm_windows_function_app" "negative3-3" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id

   site_config {
    http2_enabled = true
  }
}

resource "azurerm_windows_function_app" "negative3-4" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id
}


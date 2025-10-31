resource "azurerm_windows_web_app" "negative3-1" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_windows_web_app_plan.example.id

  site_config {}

  client_certificate_enabled = true
}

resource "azurerm_windows_web_app" "negative3-2" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    http2_enabled            = true
  }
}

resource "azurerm_windows_web_app" "negative3-3" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_windows_web_app_plan.example.id

  site_config {
    http2_enabled            = true
  }

  client_certificate_enabled = false
}

resource "azurerm_windows_web_app" "negative3-4" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_windows_web_app_plan.example.id

  site_config {
    http2_enabled            = false
  }

  client_certificate_enabled = true
}

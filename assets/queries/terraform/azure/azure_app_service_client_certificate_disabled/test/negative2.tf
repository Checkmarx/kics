resource "azurerm_linux_web_app" "negative2-1" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_linux_web_app_plan.example.id

  site_config {}

  client_certificate_enabled = true
}

resource "azurerm_linux_web_app" "negative2-2" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    http2_enabled            = true
  }
}

resource "azurerm_linux_web_app" "negative2-3" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_linux_web_app_plan.example.id

  site_config {
    http2_enabled            = true
  }

  client_certificate_enabled = false
}

resource "azurerm_linux_web_app" "negative2-4" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_linux_web_app_plan.example.id

  site_config {
    http2_enabled            = false
  }

  client_certificate_enabled = true
}

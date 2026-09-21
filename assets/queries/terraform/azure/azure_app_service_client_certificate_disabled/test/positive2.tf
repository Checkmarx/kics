resource "azurerm_linux_web_app" "positive2-1" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_linux_web_app_plan.example.id
  site_config {}
}

resource "azurerm_linux_web_app" "positive2-2" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_linux_web_app_plan.example.id

  site_config{}

  client_certificate_enabled = false
}

resource "azurerm_linux_web_app" "positive2-3" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_linux_web_app_plan.example.id

  site_config {
    http2_enabled            = false
  }

  client_certificate_enabled = false
}

resource "azurerm_linux_web_app" "positive2-4" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_linux_web_app_plan.example.id

  site_config {
    http2_enabled            = false
  }
}

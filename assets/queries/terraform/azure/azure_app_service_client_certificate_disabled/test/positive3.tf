resource "azurerm_windows_web_app" "positive3-1" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_windows_web_app_plan.example.id
}

resource "azurerm_windows_web_app" "positive3-2" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_windows_web_app_plan.example.id

  client_certificate_enabled = false
}

resource "azurerm_windows_web_app" "positive3-3" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_windows_web_app_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    http2_enabled            = false
  }

  client_certificate_enabled = false
}

resource "azurerm_linux_web_app" "positive2-1" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_linux_web_app_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  https_only = false
}

resource "azurerm_linux_web_app" "positive2-2" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id = azurerm_linux_web_app_plan.example.id
  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}
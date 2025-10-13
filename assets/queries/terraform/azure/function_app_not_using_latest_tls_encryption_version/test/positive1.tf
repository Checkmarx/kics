resource "azurerm_function_app" "positive1-1" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  app_service_plan_id        = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    min_tls_version = 1.1
  }
}

resource "azurerm_function_app" "positive1-2" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  app_service_plan_id        = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    min_tls_version = "1.1"
  }
}

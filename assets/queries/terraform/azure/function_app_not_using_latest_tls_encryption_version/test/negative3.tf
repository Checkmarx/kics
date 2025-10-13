resource "azurerm_windows_function_app" "negative3-1" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  service_plan_id            = azurerm_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    minimum_tls_version = 1.3
  }
}

resource "azurerm_windows_function_app" "negative3-2" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  service_plan_id            = azurerm_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    minimum_tls_version = "1.3"
  }
}
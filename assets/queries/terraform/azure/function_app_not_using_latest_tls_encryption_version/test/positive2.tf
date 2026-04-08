resource "azurerm_linux_function_app" "positive2-1" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  service_plan_id            = azurerm_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    minimum_tls_version = 1.1
  }
}

resource "azurerm_linux_function_app" "positive2-2" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  service_plan_id            = azurerm_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    minimum_tls_version = "1.1"
  }
}


resource "azurerm_linux_function_app" "positive2-3" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  service_plan_id            = azurerm_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}

resource "azurerm_linux_function_app" "positive2-4" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.example.location
  service_plan_id            = azurerm_service_plan.example.id
}

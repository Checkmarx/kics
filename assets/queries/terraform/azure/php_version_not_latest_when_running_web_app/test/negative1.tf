resource "azurerm_app_service" "example1" {
  name                = "example1-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
  
  # SiteConfig block is optional before AzureRM version 3.0 
  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    php_version              = "8.1"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

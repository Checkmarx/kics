resource "azurerm_windows_function_app" "positive3-1" {
  name                = "example-app-service"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}

resource "azurerm_windows_function_app" "positive3-2" {
  name                = "example-app-service"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id
  auth_settings {
    enabled = false
  }
  site_config {}
}

resource "azurerm_windows_function_app" "positive3-3" {
  name                = "example-app-service"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id
  auth_settings_v2 {
    login {}
  }
  site_config {}
}

resource "azurerm_windows_function_app" "positive3-4" {
  name                = "example-app-service"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id
  auth_settings_v2 {
    login {}
    auth_enabled = false
  }
  site_config {}
}

resource "azurerm_windows_function_app" "positive3-5" {
  name                = "example-app-service"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id
  auth_settings {
    enabled = true
  }
  auth_settings_v2 {
    login {}
  }
  site_config {}
}

resource "azurerm_windows_function_app" "positive3-6" {
  name                = "example-app-service"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id
  auth_settings {
    enabled = true
  }
  auth_settings_v2 {
    login {}
    auth_enabled = false
  }
  site_config {}
}
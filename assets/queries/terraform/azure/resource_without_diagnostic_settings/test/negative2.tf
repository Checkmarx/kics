resource "azurerm_key_vault" "example" {
  name                        = "example-keyvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
}

resource "azurerm_application_gateway" "example" {
  name                = "example-appgateway"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_firewall" "example" {
  name                = "testfirewall"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
}

resource "azurerm_lb" "example" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

resource "azurerm_frontdoor" "example" {
  name                = "example-FrontDoor"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_cdn_frontdoor_profile" "example" {
  name                     = "example-cdn-profile"
  resource_group_name      = azurerm_resource_group.example.name
  sku_name                 = "Premium_AzureFrontDoor"
  response_timeout_seconds = 120
}

resource "azurerm_cdn_frontdoor_endpoint" "example" {
  name                     = "example-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
}

resource "azurerm_cdn_profile" "example" {
  name                = "exampleCdnProfile"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "example" {
  name                = "example"
  profile_name        = azurerm_cdn_profile.example.name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_storage_account" "example" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_mssql_server" "example" {
  name                         = "mssqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_managed_instance" "example" {
  name                = "managedsqlinstance"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_mssql_database" "example" {
  name         = "example-db"
  server_id    = azurerm_mssql_server.example.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"
}

resource "azurerm_cosmosdb_account" "example" {
  name                = "tfex-cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
  kind                = "MongoDB"
}

resource "azurerm_linux_web_app" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}

resource "azurerm_windows_web_app" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}

resource "azurerm_linux_function_app" "example" {
  name                = "example-linux-function-app"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  service_plan_id            = azurerm_service_plan.example.id

  site_config {}
}

resource "azurerm_windows_function_app" "example" {
  name                = "example-windows-function-app"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  service_plan_id            = azurerm_service_plan.example.id

  site_config {}
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"
}

resource "azurerm_eventhub_namespace" "example" {
  name                = "example-namespace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  capacity            = 2
}

resource "azurerm_servicebus_namespace" "example" {
  name                = "tfex-servicebus-namespace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
}

resource "azurerm_container_registry" "example" {
  name                = "containerRegistry1"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Premium"
  admin_enabled       = false
}

resource "azurerm_api_management" "example" {
  name                = "example-apim"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics1" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_key_vault.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics2" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_application_gateway.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics3" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_firewall.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics4" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_lb.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics5" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_public_ip.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics6" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_frontdoor.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics7" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_cdn_frontdoor_profile.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics8" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_cdn_frontdoor_endpoint.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics9" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_cdn_profile.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics10" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_cdn_endpoint.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics11" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_storage_account.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics12" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_mssql_server.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics13" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_mssql_managed_instance.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics14" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_mssql_database.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics15" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_cosmosdb_account.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics16" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_linux_web_app.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics17" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_windows_web_app.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics18" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_linux_function_app.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics19" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_windows_function_app.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics20" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics21" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_eventhub_namespace.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics22" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_servicebus_namespace.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics23" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_container_registry.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics24" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_api_management.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

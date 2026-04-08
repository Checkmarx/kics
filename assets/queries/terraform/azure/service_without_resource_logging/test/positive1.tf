resource "azurerm_app_service" "positive1_1" {
  name                = "positive1_1-app-service"
  location            = azurerm_resource_group.positive1_1.location
  resource_group_name = azurerm_resource_group.positive1_1.name
  app_service_plan_id = azurerm_app_service_plan.positive1_1.id
}

resource "azurerm_windows_web_app" "positive1_2" {
  name                = "positive1_2"
  resource_group_name = azurerm_resource_group.positive1_2.name
  location            = azurerm_service_plan.positive1_2.location
  service_plan_id     = azurerm_service_plan.positive1_2.id

  site_config {}
}

resource "azurerm_linux_web_app" "positive1_3" {
  name                = "positive1_3"
  resource_group_name = azurerm_resource_group.positive1_3.name
  location            = azurerm_service_plan.positive1_3.location
  service_plan_id     = azurerm_service_plan.positive1_3.id

  site_config {}
}

resource "azurerm_batch_account" "positive1_4" {
  name                                = "testbatchaccount"
  resource_group_name                 = azurerm_resource_group.positive1_4.name
  location                            = azurerm_resource_group.positive1_4.location
  pool_allocation_mode                = "BatchService"
  storage_account_id                  = azurerm_storage_account.positive1_4.id
  storage_account_authentication_mode = "StorageKeys"
}

resource "azurerm_eventhub" "positive1_5" {
  name              = "acceptanceTestEventHub"
  namespace_id      = azurerm_eventhub_namespace.positive1_5.id
  partition_count   = 2
  message_retention = 1
}

resource "azurerm_storage_account" "positive1_6" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.positive1_6.name
  location                 = azurerm_resource_group.positive1_6.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "positive1_6" {
  name               = "positive1_6"
  storage_account_id = azurerm_storage_account.positive1_6.id
}

resource "azurerm_iothub" "positive1_7" {
  name                         = "positive1_7-IoTHub"
  resource_group_name          = azurerm_resource_group.positive1_7.name
  location                     = azurerm_resource_group.positive1_7.location
  local_authentication_enabled = false
  sku {
    name     = "S1"
    capacity = "1"
  }
}

resource "azurerm_search_service" "positive1_8" {
  name                = "positive1_8-resource"
  resource_group_name = azurerm_resource_group.positive1_8.name
  location            = azurerm_resource_group.positive1_8.location
  sku                 = "standard"
}

resource "azurerm_servicebus_namespace" "positive1_9" {
  name                = "tfex-servicebus-namespace"
  location            = azurerm_resource_group.positive1_9.location
  resource_group_name = azurerm_resource_group.positive1_9.name
  sku                 = "Standard"
}

resource "azurerm_stream_analytics_job" "positive1_10" {
  name                                     = "positive1_10-job"
  resource_group_name                      = azurerm_resource_group.positive1_10.name
  location                                 = azurerm_resource_group.positive1_10.location

}

resource "azurerm_application_gateway" "positive1_11" {
  name                = "positive1_11-appgateway"
  resource_group_name = azurerm_resource_group.positive1_11.name
  location            = azurerm_resource_group.positive1_11.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
}

resource "azurerm_logic_app_standard" "positive1_12" {
  name                       = "positive1_12-logic-app"
  location                   = azurerm_resource_group.positive1_12.location
  resource_group_name        = azurerm_resource_group.positive1_12.name
  app_service_plan_id        = azurerm_app_service_plan.positive1_12.id
  storage_account_name       = azurerm_storage_account.positive1_12.name
  storage_account_access_key = azurerm_storage_account.positive1_12.primary_access_key
}

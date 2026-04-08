resource "azurerm_app_service" "negative1_1" {
  name                = "negative1_1-app-service"
  location            = azurerm_resource_group.negative1_1.location
  resource_group_name = azurerm_resource_group.negative1_1.name
  app_service_plan_id = azurerm_app_service_plan.negative1_1.id
}

resource "azurerm_monitor_diagnostic_setting" "negative1_1" {
  name               = "negative1_1"
  target_resource_id = azurerm_app_service.negative1_1.id
  storage_account_id = azurerm_storage_account.negative1_1.id
}

resource "azurerm_windows_web_app" "negative1_2" {
  name                = "negative1_2"
  resource_group_name = azurerm_resource_group.negative1_2.name
  location            = azurerm_service_plan.negative1_2.location
  service_plan_id     = azurerm_service_plan.negative1_2.id

  site_config {}
}

resource "azurerm_monitor_diagnostic_setting" "negative1_2" {
  name               = "negative1_2"
  target_resource_id = azurerm_windows_web_app.negative1_2.id
  storage_account_id = azurerm_storage_account.negative1_2.id
}

resource "azurerm_linux_web_app" "negative1_3" {
  name                = "negative1_3"
  resource_group_name = azurerm_resource_group.negative1_3.name
  location            = azurerm_service_plan.negative1_3.location
  service_plan_id     = azurerm_service_plan.negative1_3.id

  site_config {}
}

resource "azurerm_monitor_diagnostic_setting" "negative1_3" {
  name               = "negative1_3"
  target_resource_id = azurerm_linux_web_app.negative1_3.id
  storage_account_id = azurerm_storage_account.negative1_3.id
}

resource "azurerm_batch_account" "negative1_4" {
  name                                = "testbatchaccount"
  resource_group_name                 = azurerm_resource_group.negative1_4.name
  location                            = azurerm_resource_group.negative1_4.location
  pool_allocation_mode                = "BatchService"
  storage_account_id                  = azurerm_storage_account.negative1_4.id
  storage_account_authentication_mode = "StorageKeys"
}

resource "azurerm_monitor_diagnostic_setting" "negative1_4" {
  name               = "negative1_4"
  target_resource_id = azurerm_batch_account.negative1_4.id
  storage_account_id = azurerm_storage_account.negative1_4.id
}

resource "azurerm_eventhub" "negative1_5" {
  name              = "acceptanceTestEventHub"
  namespace_id      = azurerm_eventhub_namespace.negative1_5.id
  partition_count   = 2
  message_retention = 1
}

resource "azurerm_monitor_diagnostic_setting" "negative1_5" {
  name               = "negative1_5"
  target_resource_id = azurerm_eventhub.negative1_5.id
  storage_account_id = azurerm_storage_account.negative1_5.id
}

resource "azurerm_storage_account" "negative1_6" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.negative1_6.name
  location                 = azurerm_resource_group.negative1_6.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "negative1_6" {
  name               = "negative1_6"
  storage_account_id = azurerm_storage_account.negative1_6.id
}

resource "azurerm_monitor_diagnostic_setting" "negative1_6" {
  name               = "negative1_6"
  target_resource_id = azurerm_storage_account.negative1_6.id
  storage_account_id = azurerm_storage_account.negative1_6.id
}

resource "azurerm_iothub" "negative1_7" {
  name                         = "negative1_7-IoTHub"
  resource_group_name          = azurerm_resource_group.negative1_7.name
  location                     = azurerm_resource_group.negative1_7.location
  local_authentication_enabled = false
  sku {
    name     = "S1"
    capacity = "1"
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative1_7" {
  name               = "negative1_7"
  target_resource_id = azurerm_iothub.negative1_7.id
  storage_account_id = azurerm_storage_account.negative1_7.id
}

resource "azurerm_search_service" "negative1_8" {
  name                = "negative1_8-resource"
  resource_group_name = azurerm_resource_group.negative1_8.name
  location            = azurerm_resource_group.negative1_8.location
  sku                 = "standard"
}

resource "azurerm_monitor_diagnostic_setting" "negative1_8" {
  name               = "negative1_8"
  target_resource_id = azurerm_search_service.negative1_8.id
  storage_account_id = azurerm_storage_account.negative1_8.id
}

resource "azurerm_servicebus_namespace" "negative1_9" {
  name                = "tfex-servicebus-namespace"
  location            = azurerm_resource_group.negative1_9.location
  resource_group_name = azurerm_resource_group.negative1_9.name
  sku                 = "Standard"
}

resource "azurerm_monitor_diagnostic_setting" "negative1_9" {
  name               = "negative1_9"
  target_resource_id = azurerm_servicebus_namespace.negative1_9.id
  storage_account_id = azurerm_storage_account.negative1_9.id
}

resource "azurerm_stream_analytics_job" "negative1_10" {
  name                                     = "negative1_10-job"
  resource_group_name                      = azurerm_resource_group.negative1_10.name
  location                                 = azurerm_resource_group.negative1_10.location
}

resource "azurerm_monitor_diagnostic_setting" "negative1_10" {
  name               = "negative1_10"
  target_resource_id = azurerm_stream_analytics_job.negative1_10.id
  storage_account_id = azurerm_storage_account.negative1_10.id
}

resource "azurerm_application_gateway" "negative1_11" {
  name                = "negative1_11-appgateway"
  resource_group_name = azurerm_resource_group.negative1_11.name
  location            = azurerm_resource_group.negative1_11.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative1_11" {
  name               = "negative1_11"
  target_resource_id = azurerm_application_gateway.negative1_11.id
  storage_account_id = azurerm_storage_account.negative1_11.id
}

resource "azurerm_logic_app_standard" "negative1_12" {
  name                       = "negative1_12-logic-app"
  location                   = azurerm_resource_group.negative1_12.location
  resource_group_name        = azurerm_resource_group.negative1_12.name
  app_service_plan_id        = azurerm_app_service_plan.negative1_12.id
  storage_account_name       = azurerm_storage_account.negative1_12.name
  storage_account_access_key = azurerm_storage_account.negative1_12.primary_access_key
}

resource "azurerm_monitor_diagnostic_setting" "negative1_12" {
  name               = "negative1_12"
  target_resource_id = azurerm_logic_app_standard.negative1_12.id
  storage_account_id = azurerm_storage_account.negative1_12.id
}

resource "azurerm_data_lake_analytics_account" "negative2_1" {         # legacy
  default_store_account_name = var.default_store_account_name
  location                   = var.location
  name                       = var.name
  resource_group_name        = var.resource_group_name
  tags                       = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "negative2_1" {
  name               = "negative2_1"
  target_resource_id = azurerm_data_lake_analytics_account.negative2_1.id
  storage_account_id = azurerm_storage_account.negative2_1.id
}

resource "azurerm_data_lake_store" "negative2_2" {                  # legacy
  name                = "consumptiondatalake"
  resource_group_name = azurerm_resource_group.negative2_2.name
  location            = azurerm_resource_group.negative2_2.location
  encryption_state    = "Enabled"
  encryption_type     = "ServiceManaged"
}

resource "azurerm_monitor_diagnostic_setting" "negative2_2" {
  name               = "negative2_2"
  target_resource_id = azurerm_data_lake_store.negative2_2.id
  storage_account_id = azurerm_storage_account.negative2_2.id
}

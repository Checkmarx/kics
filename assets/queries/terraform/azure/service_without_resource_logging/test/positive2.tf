resource "azurerm_data_lake_analytics_account" "positive2_1" {         # legacy
  default_store_account_name = var.default_store_account_name
  location                   = var.location
  name                       = var.name
  resource_group_name        = var.resource_group_name
  tags                       = var.tags
}

resource "azurerm_data_lake_store" "positive2_2" {                  # legacy
  name                = "consumptiondatalake"
  resource_group_name = azurerm_resource_group.positive2_2.name
  location            = azurerm_resource_group.positive2_2.location
  encryption_state    = "Enabled"
  encryption_type     = "ServiceManaged"
}

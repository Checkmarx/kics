resource "azurerm_databricks_workspace" "positive1" {
  name                = "my-databricks-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard_or_trial"  # must be 'premium' to support CMK (can be 'standard' or 'trial')

  customer_managed_key_enabled      = true
  managed_disk_cmk_key_vault_key_id = azurerm_key_vault_key.cmk.id
}

resource "azurerm_databricks_workspace" "positive2" {
  name                = "my-databricks-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "premium"

  # Undefined 'customer_managed_key_enabled'
}

resource "azurerm_databricks_workspace" "positive3" {
  name                = "my-databricks-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "premium"

  customer_managed_key_enabled      = false  # Should be true
}

resource "azurerm_databricks_workspace" "positive4" {
  name                = "my-databricks-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "premium"

  customer_managed_key_enabled      = true
  # Undefined "managed_disk_cmk_key_vault_key_id"
}

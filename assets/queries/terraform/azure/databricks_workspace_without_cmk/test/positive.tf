resource "azurerm_databricks_workspace" "positive1" {
  name                = "my-databricks-workspace"
  resource_group_name = azurerm_resource_group.positive1.name
  location            = azurerm_resource_group.positive1.location
  sku                 = "premium"

  customer_managed_key_enabled      = true
  # missing "managed_disk_cmk_key_vault_key_id"
}

resource "azurerm_databricks_workspace" "positive2" {
  name                = "my-databricks-workspace"
  resource_group_name = azurerm_resource_group.positive2.name
  location            = azurerm_resource_group.positive2.location
  sku                 = "premium"

  customer_managed_key_enabled      = false  # Should be true
  managed_disk_cmk_key_vault_key_id = azurerm_key_vault_key.cmk.id
}

resource "azurerm_databricks_workspace" "positive3" {
  name                = "my-databricks-workspace"
  resource_group_name = azurerm_resource_group.positive3.name
  location            = azurerm_resource_group.positive3.location
  sku                 = "premium"

  customer_managed_key_enabled      = false  # Should be true
  # missing "managed_disk_cmk_key_vault_key_id"
}

resource "azurerm_databricks_workspace" "positive4" {
  name                = "my-databricks-workspace"
  resource_group_name = azurerm_resource_group.positive4.name
  location            = azurerm_resource_group.positive4.location
  sku                 = "premium"

  # missing "customer_managed_key_enabled"
  managed_disk_cmk_key_vault_key_id     = azurerm_key_vault_key.cmk.id
}

resource "azurerm_databricks_workspace" "positive5" {
  name                = "my-databricks-workspace"
  resource_group_name = azurerm_resource_group.positive5.name
  location            = azurerm_resource_group.positive5.location
  sku                 = "premium"

  # missing "customer_managed_key_enabled" and "managed_disk_cmk_key_vault_key_id"
}

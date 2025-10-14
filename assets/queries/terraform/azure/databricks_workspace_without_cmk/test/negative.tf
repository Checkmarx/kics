resource "azurerm_databricks_workspace" "example" {
  name                = "my-databricks-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "premium"  # Required for CMK support

  customer_managed_key_enabled      = true  # Enables CMK
  managed_disk_cmk_key_vault_key_id = azurerm_key_vault_key.cmk.id  # Your CMK key
}

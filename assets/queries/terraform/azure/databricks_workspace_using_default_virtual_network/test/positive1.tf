resource "azurerm_databricks_workspace" "example" {
  name                        = "example-dbw"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  sku                         = "premium"
  managed_resource_group_name = "example-managed-rg"

}

resource "azurerm_databricks_workspace" "negative" {
  name                        = "example-dbw"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  sku                         = "premium"
  managed_resource_group_name = "example-managed-rg"

  custom_parameters {
    virtual_network_id                             = azurerm_virtual_network.example.id
  }
}

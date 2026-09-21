resource "azurerm_databricks_workspace" "example_1" {
  name                        = "example-dbw"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  sku                         = "premium"
  managed_resource_group_name = "example-managed-rg"

  # Missing "custom_parameters"
}

resource "azurerm_databricks_workspace" "example_2" {
  name                        = "example-dbw"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  sku                         = "premium"
  managed_resource_group_name = "example-managed-rg"

  custom_parameters { # Empty "custom_parameters"
  }
}

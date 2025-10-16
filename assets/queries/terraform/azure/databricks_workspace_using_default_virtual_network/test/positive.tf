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

resource "azurerm_databricks_workspace" "example_3" {
  name                        = "example-dbw"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  sku                         = "premium"
  managed_resource_group_name = "example-managed-rg"

  custom_parameters {
    virtual_network_id                             = azurerm_virtual_network.example.id
    # Missing "private_subnet_network_security_group_association_id", "public_subnet_network_security_group_association_id", "private_subnet_name" and "public_subnet_name"
  }
}

resource "azurerm_databricks_workspace" "example_4" {
  name                        = "example-dbw"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  sku                         = "premium"
  managed_resource_group_name = "example-managed-rg"

  custom_parameters {
    virtual_network_id                             = azurerm_virtual_network.example.id
    public_subnet_name                             = azurerm_subnet.example.name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
    # Missing "private_subnet_network_security_group_association_id" and "private_subnet_name"
  }
}

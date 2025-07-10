resource "azurerm_resource_group" "example" {
  name     = "positive-object-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "negative4" {
  name                = "virtnetname"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "negative4" {
  name                 = "subnetname"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.positive_object.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_storage_account" "negative4" {
  name                     = "positiveobjectstorage"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = true

  network_rules {
    default_action             = "Allow"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.positive_object.id]
  }

  tags = {
    environment            = "staging"
    bdo-attached-service   = "function"
  }
}

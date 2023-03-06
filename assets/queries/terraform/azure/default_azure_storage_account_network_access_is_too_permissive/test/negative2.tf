resource "azurerm_resource_group" "example" {
  name     = "negative2-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "negative2" {
  name                = "negative2-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "negative2" {
  name                 = "negative2-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.negative2.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_storage_account" "negative2" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_account_network_rules" "negative2" {
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_name = azurerm_storage_account.negative2.name
  storage_account_id = azurerm_storage_account.negative2.id

  default_action             = "Deny"
  ip_rules                   = ["127.0.0.1"]
  virtual_network_subnet_ids = [azurerm_subnet.negative2.id]
  bypass                     = ["Metrics"]
}

resource "azurerm_storage_account_network_rules" "negative2b" {
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_name = azurerm_storage_account.negative3.name
  storage_account_id = azurerm_storage_account.negative3.id

  default_action             = "Deny"
  ip_rules                   = ["127.0.0.1"]
  virtual_network_subnet_ids = [azurerm_subnet.negative2.id]
  bypass                     = ["Metrics"]
}

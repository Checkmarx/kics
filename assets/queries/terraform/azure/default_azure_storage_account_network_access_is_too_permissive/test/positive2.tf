resource "azurerm_resource_group" "example" {
  name     = "positive2-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "positive2" {
  name                = "positive2-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "positive2" {
  name                 = "positive2-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.positive2.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_storage_account" "positive2" {
  name                     = "positive2storageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_account_network_rules" "positive2" {
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_name = azurerm_storage_account.positive2.name
  storage_account_id = azurerm_storage_account.positive2.id

  default_action             = "Allow"
  ip_rules                   = ["127.0.0.1"]
  virtual_network_subnet_ids = [azurerm_subnet.positive2.id]
  bypass                     = ["Metrics"]
}

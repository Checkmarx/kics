resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "negative2" {
  name                     = "negative2"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
  }

  tags = {
    environment = "staging"
  }
}
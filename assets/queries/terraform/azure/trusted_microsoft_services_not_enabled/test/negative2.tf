locals {
  tags_resources = {
    environment = "staging"
  }
}

resource "azurerm_storage_account" "negative3" {
  name                = "storageaccountname"
  resource_group_name = azurerm_resource_group.example.name

  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    bypass                    = ["AzureServices"]
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.example.id]
  }

  tags = merge(local.tags_resources, { "bdo-attached-service" = "function", bdo_name_service = "storage_account" })
}

resource "azurerm_storage_account_network_rules" "negative4" {
  resource_group_name  = azurerm_resource_group.test.name
  storage_account_name = azurerm_storage_account.test.name

  default_action             = "Allow"
  ip_rules                   = ["127.0.0.1"]
  virtual_network_subnet_ids = [azurerm_subnet.test.id]
  bypass                     = ["Metrics", "AzureServices"]

  tags = merge(local.tags_resources, { "bdo-attached-service" = "function", bdo_name_service = "storage_account" })
}

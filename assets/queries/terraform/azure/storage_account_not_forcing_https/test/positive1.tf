# IncorrectValue for enable_https_traffic_only
resource "azurerm_storage_account" "example1" {
  name                      = "example1"
  resource_group_name       = data.azurerm_resource_group.example.name
  location                  = data.azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = false
}

# MissingAttribute for enable_https_traffic_only
resource "azurerm_storage_account" "example2" {
  name                      = "example2"
  resource_group_name       = data.azurerm_resource_group.example.name
  location                  = data.azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
}

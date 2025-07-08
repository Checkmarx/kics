# IncorrectValue for https_traffic_only_enabled
resource "azurerm_storage_account" "example1" {
  name                      = "example1"
  resource_group_name       = data.azurerm_resource_group.example.name
  location                  = data.azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  https_traffic_only_enabled = false
}

# MissingAttribute for https_traffic_only_enabled
resource "azurerm_storage_account" "example2" {
  name                      = "example2"
  resource_group_name       = data.azurerm_resource_group.example.name
  location                  = data.azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
}

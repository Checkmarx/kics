resource "azurerm_storage_account" "negative2" {
  name                      = "example"
  resource_group_name       = data.azurerm_resource_group.example.name
  location                  = data.azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  https_traffic_only_enabled = true
}

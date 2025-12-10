resource "azurerm_storage_account" "negative1" {
  name                     = "negative1"
  resource_group_name      = "testRG"
  location                 = "northeurope"
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"

  # missing "cross_tenant_replication_enabled" - defaults to false
}

resource "azurerm_storage_account" "negative2" {
  name                     = "negative2"
  resource_group_name      = "testRG"
  location                 = "northeurope"
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"

  cross_tenant_replication_enabled = false
}

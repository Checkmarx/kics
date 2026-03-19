resource "azurerm_storage_account" "fail_2" {
  name                     = "st-block-no-id"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  customer_managed_key {
    user_assigned_identity_id = "some-id"
  }
}
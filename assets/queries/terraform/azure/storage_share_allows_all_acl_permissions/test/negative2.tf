resource "azurerm_storage_share" "negative2" {
  name                 = "neg2"
  storage_account_name = azurerm_storage_account.invalid_resource.name
  quota                = 50

  acl {
    id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"

    access_policy {
      permissions = "rwdl"
      start       = "2022-07-02T09:38:21.0000000Z"
      expiry      = "2021-07-02T10:38:21.0000000Z"
    }
  }
}





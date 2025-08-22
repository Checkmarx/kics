resource "azurerm_storage_share_file" "positive1" {
  name             = "my-awesome-content.zip"
  storage_share_id = azurerm_storage_share.default_storage_share.id
  source           = "some-local-file.zip"
}

resource "azurerm_storage_share" "default_storage_share" {
  name                 = "sharename"
  storage_account_name = azurerm_storage_account.example.name
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

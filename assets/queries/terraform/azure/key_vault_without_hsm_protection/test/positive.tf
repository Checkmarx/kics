resource "azurerm_key_vault_key" "positive1" {
  name         = "positive1-certificate"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
}

resource "azurerm_key_vault_key" "positive2" {
  name         = "positive2-certificate"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "EC"
  key_size     = 2048
}

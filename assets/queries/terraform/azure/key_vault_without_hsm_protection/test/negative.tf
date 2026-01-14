resource "azurerm_key_vault_key" "negative1" {
  name         = "negative1-certificate"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA-HSM"
  key_size     = 2048
}

resource "azurerm_key_vault_key" "negative2" {
  name         = "negative2-certificate"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "EC-HSM"
  key_size     = 2048
}

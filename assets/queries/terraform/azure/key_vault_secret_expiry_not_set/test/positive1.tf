resource "azurerm_key_vault_secret" "fail" {
  name         = "my-secret"
  value        = "super-secret-value"
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "pass" {
  name            = "my-secret"
  value           = "super-secret-value"
  key_vault_id    = azurerm_key_vault.kv.id
  expiration_date = "2027-01-01T00:00:00Z"
}

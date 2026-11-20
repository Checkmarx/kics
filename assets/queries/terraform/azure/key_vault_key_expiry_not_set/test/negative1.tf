resource "azurerm_key_vault_key" "pass" {
  name            = "my-key"
  key_vault_id    = azurerm_key_vault.kv.id
  key_type        = "RSA"
  key_size        = 2048
  key_opts        = ["decrypt", "encrypt", "sign", "verify"]
  expiration_date = "2027-01-01T00:00:00Z"
}

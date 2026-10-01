resource "azurerm_key_vault_key" "fail" {
  name         = "my-key"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "verify"]
}

resource "azurerm_key_vault_key" "fail" {
  name         = "fail-key"
  key_vault_id = "vault-id"
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt"]
}
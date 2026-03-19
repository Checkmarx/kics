resource "azurerm_key_vault_key" "pass" {
  name         = "pass-key"
  key_vault_id = "vault-id"
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt"]

  rotation_policy {
    expire_after         = "P90D"
    notify_before_expiry = "P29D"

    automatic {
      time_before_expiry = "P30D"
    }
  }
}
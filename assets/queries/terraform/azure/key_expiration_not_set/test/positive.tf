resource "azurerm_key_vault_key" "positive1" {
    name         = "generated-certificate"
    key_vault_id = azurerm_key_vault.example.id
    key_type     = "RSA"
    key_size     = 2048

    key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
    ]
}
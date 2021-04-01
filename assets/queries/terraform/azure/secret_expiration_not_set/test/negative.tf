resource "azurerm_key_vault_secret" "negative1" {
    name         = "secret-sauce"
    value        = "szechuan"
    key_vault_id = azurerm_key_vault.example.id

    tags = {
    environment = "Production"
    }
    expiration_date = "2020-12-30T20:00:00Z"
}
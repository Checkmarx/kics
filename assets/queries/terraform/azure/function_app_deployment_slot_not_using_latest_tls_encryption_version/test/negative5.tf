resource "azurerm_windows_function_app_slot" "negative5" {
  name                 = "example-slot"
  function_app_id      = azurerm_windows_function_app.example.id
  storage_account_name = azurerm_storage_account.example.name

  site_config {
    minimum_tls_version = "1.2"
  }
}
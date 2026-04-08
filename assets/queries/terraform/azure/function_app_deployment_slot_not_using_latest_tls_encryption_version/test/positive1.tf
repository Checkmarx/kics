resource "azurerm_linux_function_app_slot" "positive1" {
  name                 = "example-linux-function-app-slot"
  function_app_id      = azurerm_linux_function_app.example.id
  storage_account_name = azurerm_storage_account.example.name

  site_config {
    minimum_tls_version = "1.1"
  }
}
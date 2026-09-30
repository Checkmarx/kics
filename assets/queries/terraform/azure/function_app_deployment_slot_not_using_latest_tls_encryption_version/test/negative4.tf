resource "azurerm_windows_function_app_slot" "negative4" {
  name                 = "example-slot"
  function_app_id      = azurerm_windows_function_app.example.id
  storage_account_name = azurerm_storage_account.example.name

  site_config {}
}
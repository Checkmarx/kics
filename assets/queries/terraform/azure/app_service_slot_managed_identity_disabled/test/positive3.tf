resource "azurerm_windows_web_app_slot" "positive3" {
  name           = "example-slot"
  app_service_id = azurerm_windows_web_app.example.id

  site_config {}
}
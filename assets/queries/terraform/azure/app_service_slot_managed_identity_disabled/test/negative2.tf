resource "azurerm_linux_web_app_slot" "negative2" {
  name           = "example-slot"
  app_service_id = azurerm_linux_web_app.example.id

  site_config {}

  identity {
    type = "SystemAssigned, UserAssigned"
  }
}
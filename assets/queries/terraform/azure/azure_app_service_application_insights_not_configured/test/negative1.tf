# Caso con Connection String (Recomendado)
resource "azurerm_linux_web_app" "pass_connection_string" {
  name                = "pass-app-1"
  resource_group_name = "rg"
  location            = "West Europe"
  service_plan_id     = "plan-id"

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = "InstrumentationKey=0000;IngestionEndpoint=https://..."
  }
}
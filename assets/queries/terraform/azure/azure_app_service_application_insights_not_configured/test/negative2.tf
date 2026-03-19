# Caso con Instrumentation Key (Legacy)
resource "azurerm_windows_web_app" "pass_instrumentation_key" {
  name                = "pass-app-2"
  resource_group_name = "rg"
  location            = "West Europe"
  service_plan_id     = "plan-id"

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "0000-0000-0000-0000"
  }
}
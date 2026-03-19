# Regla KICS: App Service Application Insights Not Configured

## Descripción General

Esta regla verifica que los servicios de Azure App Service y Function Apps tengan configurada la integración con **Application Insights**.

Application Insights es una característica de Azure Monitor que proporciona gestión del rendimiento de aplicaciones (APM) y seguimiento de errores en tiempo real. Para vincular un App Service con Application Insights en Terraform, se debe definir `APPLICATIONINSIGHTS_CONNECTION_STRING` (recomendado) o `APPINSIGHTS_INSTRUMENTATIONKEY` dentro del bloque `app_settings`.

## Lógica de la Regla

La política itera sobre los recursos `azurerm_linux_web_app`, `azurerm_windows_web_app`, `azurerm_linux_function_app` y `azurerm_windows_function_app`.
Verifica la configuración en dos niveles:
1.  **Ausencia de app_settings:** Si el bloque no está definido.
2.  **Configuración incompleta:** Si el bloque existe pero no contiene las claves de conexión.

## Casos de Fallo Detectados

### Caso 1: Falta Configuración en app_settings

* **Descripción:** El recurso no tiene el bloque `app_settings` definido.
* **Ubicación de la Alerta:** Nivel de recurso principal.

### Caso 2: Claves de App Insights ausentes

* **Descripción:** El bloque `app_settings` existe pero no contiene `APPLICATIONINSIGHTS_CONNECTION_STRING` ni `APPINSIGHTS_INSTRUMENTATIONKEY`.
* **Ubicación de la Alerta:** Atributo `app_settings`.

## Recurso Involucrado

* `azurerm_linux_web_app`
* `azurerm_windows_web_app`
* `azurerm_linux_function_app`
* `azurerm_windows_function_app`

## Solución

Defina `APPLICATIONINSIGHTS_CONNECTION_STRING` dentro de los `app_settings`.

```terraform
resource "azurerm_linux_web_app" "example" {
  name                = "example-app"
  # ...
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.example.connection_string
  }
}
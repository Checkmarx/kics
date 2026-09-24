# Regla KICS: App Service HTTP Logs Disabled

## Descripción General

Esta regla verifica que los servicios de Azure App Service (`azurerm_linux_web_app` y `azurerm_windows_web_app`) tengan habilitados los logs HTTP.

Los logs de HTTP registran las solicitudes web que recibe la aplicación, incluyendo la URL solicitada, el agente de usuario, la dirección IP del cliente y el código de estado de la respuesta. Esta información es fundamental para la auditoría de seguridad, el cumplimiento normativo y la resolución de problemas de tráfico.

## Lógica de la Regla

La política itera sobre los recursos de App Service y verifica la configuración en dos pasos:
1.  **Ausencia de Logs:** Verifica si el bloque `logs` existe.
2.  **Ausencia de Logs HTTP:** Si el bloque `logs` existe, verifica que contenga el sub-bloque `http_logs`.

Si el logging HTTP no está explícitamente habilitado, se genera una alerta.

## Casos de Fallo Detectados

### Caso 1: Configuración de Logs Ausente

* **Descripción:** El recurso App Service se define sin especificar ninguna configuración de `logs`.
* **Ubicación de la Alerta:** Nivel de recurso principal.

### Caso 2: Bloque http_logs Omitido

* **Descripción:** Se define el bloque `logs` (por ejemplo, para logs de aplicación), pero se omiten los logs de tráfico HTTP.
* **Ubicación de la Alerta:** Bloque `logs`.

## Recurso Involucrado

* `azurerm_linux_web_app`
* `azurerm_windows_web_app`

## Solución

Añada el bloque `logs` y configure `http_logs` definiendo un sistema de archivos (`file_system`) o un almacenamiento de blobs (`azure_blob_storage`).

```terraform
resource "azurerm_linux_web_app" "example_secure" {
  name                = "example-linux-web-app-secure"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}
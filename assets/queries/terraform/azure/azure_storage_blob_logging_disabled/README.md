# Regla KICS: Storage Blob Service Logging Disabled

## Descripción General

Esta regla verifica que el registro de diagnóstico (**Diagnostic Settings**) esté habilitado y configurado íntegramente para el servicio de **Blobs** en las cuentas de almacenamiento de Azure.

Para garantizar una auditoría completa del plano de datos, es imperativo registrar las tres operaciones fundamentales que permiten rastrear el ciclo de vida de los objetos:
* **StorageRead:** Auditoría de lectura de datos de blobs y metadatos de contenedores.
* **StorageWrite:** Auditoría de subidas, creaciones y modificaciones de blobs.
* **StorageDelete:** Auditoría de eliminaciones de objetos y contenedores.

## Lógica de la Regla

La política audita el código Terraform evaluando tres niveles de cumplimiento:
1.  **Existencia de Recurso:** Verifica que cada `azurerm_storage_account` tenga un recurso `azurerm_monitor_diagnostic_setting` vinculado a su endpoint de blobs (`/blobServices/default`).
2.  **Presencia de Logs:** Alerta si el recurso de diagnóstico existe pero no contiene definiciones de registros (`enabled_log`).
3.  **Integridad de Categorías:** Analiza que las categorías `StorageRead`, `StorageWrite` y `StorageDelete` estén presentes. Si el conjunto está incompleto, la alerta apunta directamente al bloque `enabled_log`.

## Casos de Fallo Detectados

### Caso 1: Servicio de Blobs sin Diagnostic Settings
* **Ubicación:** `azurerm_storage_account`.

### Caso 2: Diagnostic Setting sin bloques de Log
* **Ubicación:** `azurerm_monitor_diagnostic_setting`.

### Caso 3: Auditoría de Blobs Incompleta
* **Descripción:** El bloque de registros no contiene el set completo de categorías (Read, Write y Delete).
* **Ubicación:** Bloque `enabled_log` dentro de `azurerm_monitor_diagnostic_setting`.

## Recursos Involucrados
* `azurerm_storage_account`
* `azurerm_monitor_diagnostic_setting`

## Solución

```terraform
resource "azurerm_monitor_diagnostic_setting" "secure_blob_logging" {
  name               = "blob-audit-complete"
  target_resource_id = "${azurerm_storage_account.example.id}/blobServices/default"
  storage_account_id = azurerm_storage_account.log_destination.id

  enabled_log { category = "StorageRead" }
  enabled_log { category = "StorageWrite" }
  enabled_log { category = "StorageDelete" }
}
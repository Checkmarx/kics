# Regla KICS: Storage Table Service Logging Disabled

## Descripción General

Esta regla verifica que el registro de diagnóstico (**Diagnostic Settings**) esté habilitado y configurado íntegramente para el servicio de **Tablas (Table Service)** en las cuentas de almacenamiento de Azure.

La auditoría de las tablas NoSQL de Azure Storage permite capturar telemetría sobre quién accede y modifica los datos almacenados. La política asegura que se capturen las tres categorías de operaciones esenciales para una trazabilidad completa:
* **StorageRead:** Auditoría de consultas de entidades y lectura de metadatos de tablas.
* **StorageWrite:** Auditoría de inserciones, actualizaciones y "upserts" de datos.
* **StorageDelete:** Auditoría de eliminaciones de entidades o de la estructura de la tabla.

Sin estos registros activos, las organizaciones carecen de la telemetría necesaria para identificar accesos no autorizados a datos sensibles o investigar errores en la manipulación de registros NoSQL.

## Lógica de la Regla

La política audita el código Terraform evaluando tres niveles de cumplimiento:
1.  **Existencia de Recurso:** Verifica que cada `azurerm_storage_account` tenga un recurso `azurerm_monitor_diagnostic_setting` vinculado a su endpoint de tablas (`/tableServices/default`).
2.  **Presencia de Logs:** Alerta si el recurso de diagnóstico existe pero el bloque `enabled_log` está ausente.
3.  **Integridad de Categorías:** Analiza que las categorías `StorageRead`, `StorageWrite` y `StorageDelete` estén presentes simultáneamente. Si el conjunto está incompleto, la alerta apunta directamente al bloque `enabled_log`.

## Casos de Fallo Detectados

### Caso 1: Servicio de Tablas sin Diagnostic Settings
* **Descripción:** La cuenta de almacenamiento no tiene configurado ningún destino de registro para tablas.
* **Ubicación:** `azurerm_storage_account`.

### Caso 2: Diagnostic Setting sin bloques de Log
* **Descripción:** El recurso de diagnóstico existe pero la configuración de registros está vacía.
* **Ubicación:** `azurerm_monitor_diagnostic_setting`.

### Caso 3: Auditoría de Tablas Incompleta
* **Descripción:** Faltan una o más categorías críticas en la configuración de logs.
* **Ubicación:** Bloque `enabled_log` dentro de `azurerm_monitor_diagnostic_setting`.

## Recursos Involucrados
* `azurerm_storage_account`
* `azurerm_monitor_diagnostic_setting`

## Solución

Configure un Diagnostic Setting completo para el servicio de tablas.

```terraform
resource "azurerm_monitor_diagnostic_setting" "secure_table_logging" {
  name               = "table-audit-complete"
  target_resource_id = "${azurerm_storage_account.example.id}/tableServices/default"
  storage_account_id = azurerm_storage_account.logs.id

  enabled_log { category = "StorageRead" }
  enabled_log { category = "StorageWrite" }
  enabled_log { category = "StorageDelete" }
}
# Regla KICS: Backup Vault Cross Region Restore Disabled

## Descripción General

Esta regla verifica que la funcionalidad de **Restauración entre Regiones** (`cross_region_restore_enabled`) esté habilitada en los recursos `azurerm_data_protection_backup_vault`.

Cross Region Restore (CRR) permite restaurar los datos de copia de seguridad en una región secundaria de Azure emparejada (Azure Paired Region). Esto es fundamental para garantizar la continuidad del negocio y la recuperación de datos en caso de que la región principal sufra una interrupción total o un desastre geográfico.

**Nota:** Para utilizar CRR de manera efectiva, el almacén requiere que la redundancia esté configurada como `GeoRedundant`.

## Lógica de la Regla

La política evalúa el recurso `azurerm_data_protection_backup_vault` bajo dos escenarios:
1.  **Atributo Ausente:** Si no se define explícitamente `cross_region_restore_enabled`, se genera una alerta sobre el recurso (ya que el valor por defecto en la plataforma suele ser false).
2.  **Deshabilitado Explícitamente:** Si el atributo se establece como `false`, la alerta apunta directamente a la línea de la configuración incorrecta.

## Casos de Fallo Detectados

---

### Caso 1: Configuración Ausente
* **Descripción:** Se define el Backup Vault sin especificar la política de restauración entre regiones, dejando los datos vulnerables a fallos regionales.
* **Ubicación de la Alerta:** Nivel de recurso `azurerm_data_protection_backup_vault`.

### Caso 2: CRR Deshabilitado
* **Descripción:** El atributo `cross_region_restore_enabled` está configurado explícitamente como `false`.
* **Ubicación de la Alerta:** Línea `cross_region_restore_enabled`.

## Recurso Involucrado

* `azurerm_data_protection_backup_vault`

## Solución

Establezca el atributo `cross_region_restore_enabled` en `true`. Es altamente recomendable verificar que el tipo de redundancia (`redundancy`) esté configurado como `GeoRedundant`.

```terraform
resource "azurerm_data_protection_backup_vault" "example_secure" {
  name                         = "vault-secure"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  datastore_type               = "VaultStore"
  redundancy                   = "GeoRedundant"

  # Solución técnica
  cross_region_restore_enabled = true
}
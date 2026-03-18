# Regla KICS: Recovery Services Vault Cross Region Restore Disabled

## Descripción General

Esta regla de KICS verifica que la funcionalidad de **Restauración entre Regiones** (`cross_region_restore_enabled`) esté habilitada en los almacenes de **Recovery Services Vault**.

Habilitar la Restauración entre Regiones (CRR) es un componente crítico de una estrategia de continuidad de negocio y recuperación ante desastres (DRP). Esta característica permite realizar restauraciones de datos en una región secundaria emparejada de Azure en cualquier momento, garantizando el acceso a los backups incluso si la región principal sufre una interrupción total o desastre regional. 

**Nota técnica:** Para que la restauración entre regiones sea efectiva, el almacén debe tener configurado el tipo de almacenamiento como `GeoRedundant`.

## Lógica de la Regla

La política analiza el recurso `azurerm_recovery_services_vault` evaluando dos condiciones:
1.  **Atributo Ausente:** Si no se define explícitamente `cross_region_restore_enabled`, se considera no conforme, ya que la configuración por defecto no garantiza la disponibilidad del dato en la región secundaria.
2.  **Configuración Incorrecta:** Si el atributo se establece explícitamente como `false`, se genera una alerta indicando la falta de redundancia operativa para restauraciones.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Configuración de CRR Ausente

* **Descripción:** El almacén se define sin especificar la política de restauración regional, lo que resulta en la desactivación por defecto de esta medida de resiliencia.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_recovery_services_vault" "fail_missing" {
      name                = "vault-insecure"
      location            = "West Europe"
      resource_group_name = azurerm_resource_group.example.name
      sku                 = "Standard"
      storage_mode_type   = "GeoRedundant"
      # Falta cross_region_restore_enabled = true
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_recovery_services_vault`.

---

### Caso 2: CRR Deshabilitado Explícitamente

* **Descripción:** Se ha configurado el atributo `cross_region_restore_enabled` con el valor `false`, impidiendo la recuperación de desastres en regiones emparejadas.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_recovery_services_vault" "fail_false" {
      name                         = "vault-disabled"
      storage_mode_type            = "GeoRedundant"
      cross_region_restore_enabled = false # <-- Problema detectado
    }
    ```
* **Ubicación de la Alerta:** Atributo `cross_region_restore_enabled`.

## Recurso Involucrado

* `azurerm_recovery_services_vault`

## Solución

Establezca `cross_region_restore_enabled` en `true` y asegúrese de que el `storage_mode_type` sea `GeoRedundant`.

```terraform
resource "azurerm_recovery_services_vault" "secure_vault" {
  name                         = "vault-resilient"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  sku                          = "Standard"
  storage_mode_type            = "GeoRedundant"

  # SOLUCIÓN: Habilitar restauración entre regiones
  cross_region_restore_enabled = true
}
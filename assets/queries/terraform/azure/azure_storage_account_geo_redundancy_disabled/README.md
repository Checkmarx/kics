# Regla KICS: Storage Account Geo-Redundancy Disabled

## Descripción General

Esta regla de KICS verifica que las cuentas de almacenamiento de Azure (`azurerm_storage_account`) estén configuradas con **Redundancia Geográfica**.

La redundancia geográfica es una estrategia de continuidad del negocio fundamental. Al habilitarla, Azure copia los datos de forma asíncrona en una región secundaria situada a cientos de kilómetros de la región principal. Esto garantiza que, ante un desastre regional catastrófico (fallos masivos de red, desastres naturales o cortes de energía en toda una región), los datos permanezcan duraderos y disponibles para su recuperación, minimizando el RPO (objetivo de punto de recuperación) y el RTO (objetivo de tiempo de recuperación).

## Lógica de la Regla

La política audita el atributo `account_replication_type` del recurso `azurerm_storage_account`:
1.  **Validación de Tipo:** Comprueba si el valor configurado pertenece al grupo de alta disponibilidad regional: `GRS`, `RAGRS`, `GZRS` o `RAGZRS`.
2.  **Detección de Riesgo:** Si el valor es `LRS` (Localmente redundante) o `ZRS` (Redundancia de zona), se genera una alerta, ya que estos niveles solo protegen contra fallos de hardware dentro de un centro de datos o zona, pero no contra la pérdida de una región completa.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Replicación Local o Zonal (LRS/ZRS)

* **Descripción:** La cuenta de almacenamiento utiliza un esquema de replicación que no se extiende fuera de la región principal, dejando los datos vulnerables ante desastres regionales.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_storage_account" "fail_storage" {
      name                     = "insecurestorage"
      resource_group_name      = azurerm_resource_group.example.name
      location                 = azurerm_resource_group.example.location
      account_tier             = "Standard"
      
      # FALLO: Replicación limitada a la región local
      account_replication_type = "LRS"
    }
    ```
* **Ubicación de la Alerta:** Atributo `account_replication_type`.

## Recurso Involucrado

* `azurerm_storage_account`

## Solución

Para mitigar este riesgo en entornos de producción, cambie el tipo de replicación a uno que soporte redundancia geográfica, como **GRS**.

```terraform
resource "azurerm_storage_account" "secure_storage" {
  name                     = "securestorage"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  
  # SOLUCIÓN: Habilitar redundancia geográfica
  account_replication_type = "GRS"
}
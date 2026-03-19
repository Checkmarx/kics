# Regla KICS: Storage Account Blob Versioning Disabled

## Descripción General

Esta regla verifica que la característica de **Versioning** (control de versiones) esté habilitada en los recursos `azurerm_storage_account`.

El control de versiones de Blobs permite mantener automáticamente versiones anteriores de un objeto cuando este se modifica o elimina. Es una capa de protección fundamental para escenarios de recuperación de datos ante errores humanos, sobreescrituras accidentales o ataques de ransomware, permitiendo restaurar un estado anterior del archivo sin necesidad de recurrir a copias de seguridad externas complejas.

## Lógica de la Regla

La política evalúa la configuración en tres niveles de granularidad:
1.  **Bloque Ausente:** Si el recurso no tiene definido el bloque `blob_properties`.
2.  **Atributo Ausente:** Si existe el bloque pero no se define el parámetro `versioning_enabled`.
3.  **Valor Incorrecto:** Si `versioning_enabled` se ha configurado explícitamente como `false`.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Configuración de Bloque Ausente

* **Descripción:** El recurso no define el bloque `blob_properties`. Por defecto, Azure deshabilita el versionado si no se especifica.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_storage_account" "fail_1" {
      name                     = "storage-insecure-1"
      resource_group_name      = "rg-prod"
      location                 = "West Europe"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      
      # El bloque blob_properties es inexistente
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_storage_account`.

---

### Caso 2: Versionado Deshabilitado Explícitamente

* **Descripción:** Se ha incluido el bloque de propiedades pero el versionado está apagado, lo que impide la recuperación de archivos modificados.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_storage_account" "fail_2" {
      name                = "storage-insecure-2"
      # ...
      blob_properties {
        versioning_enabled = false  # <-- PROBLEMA: Deshabilitado.
      }
    }
    ```
* **Ubicación de la Alerta:** Línea `versioning_enabled = false`.

## Recurso Involucrado

* `azurerm_storage_account`

## Solución

Para solucionar este riesgo, asegúrese de incluir el bloque `blob_properties` con el atributo `versioning_enabled` establecido en `true`.

```terraform
resource "azurerm_storage_account" "secure_storage" {
  name                     = "storage-secure"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # SOLUCIÓN: Habilitar el control de versiones de blobs
  blob_properties {
    versioning_enabled = true
  }
}
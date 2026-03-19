# Regla KICS: Storage Account Infrastructure Encryption Disabled

## Descripción General

Esta regla de KICS verifica que el **Cifrado de Infraestructura** (`infrastructure_encryption_enabled`) esté habilitado en los recursos `azurerm_storage_account`.

Por defecto, Azure Storage cifra todos los datos en reposo mediante el cifrado del lado del servidor (SSE) utilizando claves gestionadas por Microsoft. Sin embargo, habilitar el cifrado de infraestructura proporciona una capa de defensa en profundidad conocida como **Doble Cifrado** (Double Encryption). En este modelo, los datos se cifran dos veces: una a nivel del servicio de almacenamiento y otra a nivel de la infraestructura subyacente, utilizando dos algoritmos de cifrado independientes y claves distintas. Esto protege la información incluso en el caso improbable de que un algoritmo o clave individual se vea comprometido.

**Nota técnica:** Esta configuración es **inmutable**. Solo se puede habilitar en el momento de la creación de la cuenta de almacenamiento; no es posible activarla posteriormente sin recrear el recurso.

## Lógica de la Regla

La política audita el recurso `azurerm_storage_account` evaluando dos escenarios:
1.  **Atributo Ausente:** Si no se define explícitamente `infrastructure_encryption_enabled`, KICS asume el valor por defecto (`false`) y genera una alerta sobre el recurso.
2.  **Deshabilitado Explícitamente:** Si el atributo está configurado como `false`, se genera una alerta indicando que la protección de doble cifrado no está activa.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Configuración de Doble Cifrado Ausente

* **Descripción:** Se define la cuenta de almacenamiento sin incluir el parámetro de cifrado de infraestructura, delegando la seguridad únicamente al cifrado simple predeterminado.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_storage_account" "fail_missing" {
      name                     = "storageinsecure"
      resource_group_name      = azurerm_resource_group.example.name
      location                 = azurerm_resource_group.example.location
      account_tier             = "Standard"
      account_replication_type = "LRS"
      # Falta infrastructure_encryption_enabled = true
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_storage_account`.

---

### Caso 2: Cifrado de Infraestructura Deshabilitado Explícitamente

* **Descripción:** El atributo `infrastructure_encryption_enabled` se ha configurado como `false`, desactivando la capa de seguridad adicional requerida.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_storage_account" "fail_explicit" {
      name                              = "storagedisabled"
      # ...
      infrastructure_encryption_enabled = false # <-- Problema detectado
    }
    ```
* **Ubicación de la Alerta:** Atributo `infrastructure_encryption_enabled`.

## Recurso Involucrado

* `azurerm_storage_account`

## Solución

Para mitigar este riesgo, establezca `infrastructure_encryption_enabled` en `true` durante la definición inicial de la cuenta de almacenamiento.

```terraform
resource "azurerm_storage_account" "secure_storage" {
  name                              = "storage-secure"
  resource_group_name               = azurerm_resource_group.example.name
  location                          = azurerm_resource_group.example.location
  account_tier                      = "Standard"
  account_replication_type          = "GRS"

  # SOLUCIÓN: Habilitar el doble cifrado de infraestructura
  infrastructure_encryption_enabled = true
}
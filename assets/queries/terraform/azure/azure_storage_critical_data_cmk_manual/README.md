# Regla KICS: Critical Data Storage CMK (Manual)

## Descripción General

Esta regla identifica cuentas de almacenamiento de Azure (`azurerm_storage_account`) que utilizan cifrado gestionado por Microsoft (**Platform-Managed Keys**). 

El cifrado en reposo es automático en Azure, pero el uso de claves gestionadas por la plataforma no siempre es suficiente para cumplir con normativas de soberanía de datos o requisitos de seguridad de datos críticos. Esta regla actúa como un control de **auditoría manual**: identifica recursos sin **Customer-Managed Keys (CMK)** para que el equipo de seguridad valide si los datos contenidos (financieros, PII, secretos industriales) requieren que la organización posea y gestione las claves de cifrado en su propio Key Vault.

## Lógica de la Regla

La política audita el recurso `azurerm_storage_account` evaluando dos escenarios:
1.  **Ausencia de Configuración CMK:** Si el bloque `customer_managed_key` no está presente, la cuenta utiliza las claves por defecto de Azure.
2.  **Configuración Incompleta:** Si el bloque `customer_managed_key` existe pero no define el atributo `key_vault_key_id`, el cifrado CMK no se está aplicando efectivamente.

## Casos de Fallo Detectados

### Caso 1: Revisión de Sensibilidad de Datos Requerida (Cifrado Default)

* **Descripción:** La cuenta utiliza el cifrado base de Azure. Se requiere validación manual para determinar si la criticidad de los datos exige el paso a CMK.
* **Ubicación de la Alerta:** Recurso `azurerm_storage_account`.

### Caso 2: Bloque CMK sin Clave Asociada

* **Descripción:** Se ha declarado el bloque de claves gestionadas por el cliente pero se ha omitido el identificador de la clave criptográfica.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_storage_account" "fail_incomplete" {
      name = "stincomplete"
      # ...
      customer_managed_key {
        user_assigned_identity_id = azurerm_user_assigned_identity.example.id
        # key_vault_key_id es opcional en el esquema pero necesario para CMK
      }
    }
    ```
* **Ubicación de la Alerta:** Bloque `customer_managed_key`.

## Recurso Involucrado

* `azurerm_storage_account`

## Solución

Si tras la revisión manual se confirma que los datos son críticos, implemente CMK vinculando una clave de Azure Key Vault.

```terraform
resource "azurerm_storage_account" "secure_critical" {
  name                     = "stcriticaldata"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  identity {
    type = "SystemAssigned"
  }

  customer_managed_key {
    # SOLUCIÓN: Definir explícitamente la clave de Key Vault
    key_vault_key_id = azurerm_key_vault_key.example.id
  }
}
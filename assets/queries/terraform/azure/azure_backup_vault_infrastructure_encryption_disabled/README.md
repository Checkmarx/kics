# Regla KICS: Backup Vault Infrastructure Encryption Disabled

## Descripción General

Esta regla verifica la preparación para el cifrado avanzado en los almacenes de respaldo de Azure (**Data Protection Backup Vaults**). 

Para que un Backup Vault pueda soportar capas de cifrado adicionales o gestionadas por el cliente (CMK), es obligatorio que el recurso tenga una identidad asignada (`identity`). Sin una identidad, el almacén solo puede utilizar el cifrado predeterminado de la plataforma.

## Lógica de la Regla

La política audita el recurso `azurerm_data_protection_backup_vault`:
1.  Verifica la existencia del bloque `identity`.
2.  Si el bloque está ausente, se considera que el recurso no está preparado para configuraciones de cifrado de infraestructura o gestionado por el cliente.

## Casos de Fallo Detectados

### Caso 1: Identidad no configurada

* **Descripción:** El Backup Vault no tiene una identidad (SystemAssigned o UserAssigned), lo que impide la vinculación con claves de cifrado externas.
* **Ubicación de la Alerta:** Nivel de recurso `azurerm_data_protection_backup_vault`.

## Recurso Involucrado

* `azurerm_data_protection_backup_vault`

## Solución

Añada un bloque `identity` al recurso.

```terraform
resource "azurerm_data_protection_backup_vault" "example" {
  name                = "vault-secure"
  resource_group_name = "rg-example"
  location            = "West Europe"
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  # Solución técnica para habilitar capacidades de cifrado
  identity {
    type = "SystemAssigned"
  }
}
# Regla KICS: Backup Vault CMK Encryption Disabled

## Descripción General

Esta regla verifica que los almacenes de copias de seguridad de Azure (**Backup Vaults** del servicio Data Protection) estén cifrados utilizando **Customer-Managed Keys (CMK)**.

El uso de claves gestionadas por el cliente proporciona un control total sobre el ciclo de vida de las claves (creación, rotación y revocación) y es un requisito común en entornos con altas exigencias de seguridad y cumplimiento. En Terraform, esto se configura mediante un recurso separado (`azurerm_data_protection_backup_vault_customer_managed_key`) que vincula el Vault con la clave almacenada en un Key Vault.

## Lógica de la Regla

La política realiza un análisis de relaciones entre recursos:
1.  Identifica todos los recursos `azurerm_data_protection_backup_vault`.
2.  Busca si existe un recurso `azurerm_data_protection_backup_vault_customer_managed_key` cuya propiedad `data_protection_backup_vault_id` apunte al Vault analizado.
3.  Verifica que dicho recurso de asociación tenga definido el atributo `key_vault_key_id`.
4.  Si no existe esta vinculación, se genera una alerta indicando que el Vault usa claves gestionadas por la plataforma (configuración por defecto).

## Casos de Fallo Detectados

### Caso 1: Backup Vault sin CMK

* **Descripción:** Se define el Backup Vault pero no se encuentra el recurso de asociación de la clave de cifrado gestionada por el cliente.
* **Ubicación de la Alerta:** Sobre el recurso `azurerm_data_protection_backup_vault`.

## Recurso Involucrado

* `azurerm_data_protection_backup_vault`
* `azurerm_data_protection_backup_vault_customer_managed_key`

## Solución

Define el recurso de asociación `azurerm_data_protection_backup_vault_customer_managed_key` y vincúlalo al Vault y a la Key correspondiente.

```terraform
resource "azurerm_data_protection_backup_vault_customer_managed_key" "example" {
  data_protection_backup_vault_id = azurerm_data_protection_backup_vault.example.id
  key_vault_key_id                = azurerm_key_vault_key.example.id
}
# Regla KICS: NetApp Account CMK Encryption Disabled

## Descripción General

Esta regla de KICS verifica que las cuentas de **Azure NetApp Files** estén configuradas para utilizar claves gestionadas por el cliente (**Customer-Managed Keys - CMK**) para el cifrado de datos en reposo.

Por defecto, Azure NetApp Files cifra los datos utilizando claves gestionadas por la plataforma Microsoft. Sin embargo, para cumplir con requisitos de cumplimiento normativo y soberanía de datos, se recomienda el uso de CMK. Esto permite a las organizaciones tener el control total sobre el ciclo de vida de las claves, incluyendo la rotación y la revocación de acceso, asegurando que los volúmenes de almacenamiento de alto rendimiento estén protegidos por claves bajo el control directo del cliente en Azure Key Vault.

## Lógica de la Regla

La política analiza la configuración de Terraform buscando dos métodos válidos de implementación de CMK:
1.  **Configuración Inline:** Verifica si el recurso `azurerm_netapp_account` tiene un bloque `encryption` donde el atributo `key_source` sea explícitamente `Microsoft.KeyVault`.
2.  **Recurso Independiente:** Verifica si existe un recurso `azurerm_netapp_account_encryption` vinculado al ID de la cuenta NetApp analizada.

Si no se detecta ninguno de estos dos métodos, se genera una alerta indicando que la cuenta está operando con el cifrado predeterminado de la plataforma.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Configuración de Cifrado por Defecto (Platform Keys)

* **Descripción:** Se define la cuenta de NetApp sin habilitar el uso de Key Vault para el cifrado, dejando los datos protegidos únicamente por las claves de Microsoft.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_netapp_account" "fail" {
      name                = "insecure-netapp-account"
      resource_group_name = azurerm_resource_group.example.name
      location            = azurerm_resource_group.example.location
      
      # Falta la configuración de CMK (inline o recurso separado)
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_netapp_account`.

## Recursos Involucrados

* `azurerm_netapp_account`
* `azurerm_netapp_account_encryption`

## Solución

Para solucionar este riesgo, asigne una identidad gestionada a la cuenta y utilice el recurso `azurerm_netapp_account_encryption` para vincular la clave del Key Vault.

```terraform
resource "azurerm_netapp_account" "secure" {
  name                = "secure-netapp-account"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  
  # 1. Asignar identidad
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }
}

# 2. Configurar el cifrado CMK mediante el recurso dedicado
resource "azurerm_netapp_account_encryption" "secure_encryption" {
  netapp_account_id         = azurerm_netapp_account.secure.id
  user_assigned_identity_id = azurerm_user_assigned_identity.example.id
  encryption_key            = azurerm_key_vault_key.example.versionless_id
}
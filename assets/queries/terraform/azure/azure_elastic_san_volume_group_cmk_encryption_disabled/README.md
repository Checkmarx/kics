# Regla KICS: Elastic SAN Volume Group CMK Encryption Disabled

## Descripción General

Esta regla de KICS verifica que los grupos de volúmenes de Azure Elastic SAN (`azurerm_elastic_san_volume_group`) estén configurados para utilizar claves gestionadas por el cliente (Customer-Managed Keys - CMK) para el cifrado de datos en reposo.

El uso de CMK sobre las claves gestionadas por la plataforma por defecto es una práctica de seguridad crítica. Proporciona a las organizaciones un control total sobre el ciclo de vida de las claves criptográficas, incluyendo políticas de acceso, rotación y revocación. Esto es esencial para cumplir con requisitos regulatorios y garantizar que el acceso a los datos almacenados en la SAN esté protegido por claves bajo el control directo del cliente.

## Lógica de la Regla

La política analiza el recurso `azurerm_elastic_san_volume_group` validando dos pilares fundamentales:
1.  **Configuración del Tipo:** El atributo `encryption_type` debe estar establecido inequívocamente como `EncryptionAtRestWithCustomerManagedKey`.
2.  **Infraestructura de Soporte:** Si se selecciona CMK, el recurso debe incluir obligatoriamente los bloques `encryption` (que vincula la clave) e `identity` (que permite el acceso a la misma).

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---
### Caso 1: Cifrado CMK no Configurado (Uso de Claves de Plataforma)

* **Descripción:** El recurso carece del atributo de cifrado CMK o utiliza el valor por defecto gestionado por la plataforma.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_elastic_san_volume_group" "fail_platform" {
      name           = "example-vg"
      elastic_san_id = azurerm_elastic_san.example.id
    }
    ```
* **Ubicación de la Alerta:** Recurso raíz `azurerm_elastic_san_volume_group`.

---
### Caso 2: CMK Seleccionado con Bloques Técnicos Ausentes

* **Descripción:** Se ha activado el tipo de cifrado CMK, pero falta uno o ambos bloques (`encryption` / `identity`) necesarios para que el cifrado sea operativo.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_elastic_san_volume_group" "fail_missing_blocks" {
      encryption_type = "EncryptionAtRestWithCustomerManagedKey"
      # Falta bloque encryption o bloque identity
    }
    ```
* **Ubicación de la Alerta:** Recurso raíz `azurerm_elastic_san_volume_group`.

## Recurso Involucrado

* `azurerm_elastic_san_volume_group`

## Solución

Para solucionar el problema, asegúrese de declarar el tipo de cifrado CMK e incluir los bloques técnicos requeridos con sus parámetros obligatorios.

```terraform
resource "azurerm_elastic_san_volume_group" "secure_vg" {
  name           = "secure-volume-group"
  elastic_san_id = azurerm_elastic_san.example.id
  
  encryption_type = "EncryptionAtRestWithCustomerManagedKey"

  encryption {
    key_vault_key_id = azurerm_key_vault_key.example.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }
}
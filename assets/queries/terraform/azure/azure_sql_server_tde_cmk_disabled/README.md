# Regla KICS: SQL Server TDE Not Encrypted with CMK

## Descripción General

Esta regla de KICS asegura que la característica **Transparent Data Encryption (TDE)** de Azure SQL Server esté configurada para utilizar una **clave gestionada por el cliente (Customer-Managed Key - CMK)** almacenada en Azure Key Vault.

Por defecto, Azure SQL cifra los datos en reposo utilizando una clave gestionada por el servicio (Microsoft). Aunque este método proporciona seguridad base, el uso de CMK ofrece un nivel de control superior indispensable para cumplir con normativas estrictas de seguridad corporativa. Con CMK, la organización asume el control total sobre el ciclo de vida de las claves, permitiendo la rotación, revocación de acceso y auditoría de uso de forma soberana a través de Azure Key Vault.

## Lógica de la Regla

La política audita la configuración de Terraform siguiendo estos criterios:
1.  **Identificación:** Localiza todos los recursos de tipo `azurerm_mssql_server`.
2.  **Vinculación:** Busca si existe un recurso independiente del tipo `azurerm_mssql_server_transparent_data_encryption` vinculado al servidor mediante el atributo `server_id`.
3.  **Validación de Clave:** Verifica que dicho recurso tenga definido explícitamente el atributo `key_vault_key_id`.
4.  **Alerta:** Si no se encuentra el recurso de cifrado o si falta la referencia a la clave de Key Vault, se genera un hallazgo.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Uso de Clave Gestionada por el Servicio (Default)

* **Descripción:** Se define el servidor SQL pero no se añade el recurso adicional necesario para habilitar el cifrado TDE mediante llaves del cliente, manteniendo el cifrado por defecto de Azure.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_mssql_server" "fail_server" {
      name                         = "insecure-sql-server"
      resource_group_name          = azurerm_resource_group.example.name
      location                     = azurerm_resource_group.example.location
      version                      = "12.0"
      administrator_login          = "sqladmin"
      administrator_password       = "P@ssword123!"

      # Falta el recurso azurerm_mssql_server_transparent_data_encryption
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_mssql_server`.

## Recursos Involucrados

* `azurerm_mssql_server`
* `azurerm_mssql_server_transparent_data_encryption`

## Solución

Para mitigar este riesgo, cree un recurso `azurerm_mssql_server_transparent_data_encryption`, vincúlelo al servidor SQL y proporcione la URI de la clave de Azure Key Vault.

```terraform
resource "azurerm_mssql_server_transparent_data_encryption" "secure_tde" {
  server_id        = azurerm_mssql_server.example.id
  
  # SOLUCIÓN: Usar una clave gestionada por el cliente
  key_vault_key_id = azurerm_key_vault_key.example.id
}
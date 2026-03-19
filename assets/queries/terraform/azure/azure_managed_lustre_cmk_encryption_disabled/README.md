# Regla KICS: Azure Managed Lustre Not Encrypted with CMK

## Descripción General

Esta regla de KICS verifica que los sistemas de archivos **Azure Managed Lustre** (`azurerm_managed_lustre_file_system`) estén configurados para utilizar claves gestionadas por el cliente (**Customer-Managed Keys - CMK**) para el cifrado de datos en reposo.

Por defecto, Azure cifra los datos en Lustre utilizando claves gestionadas por la plataforma. Para cumplir con requisitos de soberanía de datos y gobernanza, se recomienda el uso de CMK mediante el bloque `encryption_key`. Esto otorga a las organizaciones control total sobre el ciclo de vida de la clave, permitiendo la rotación y revocación selectiva del acceso a los datos de alto rendimiento almacenados en el sistema de archivos.

## Lógica de la Regla

La política analiza el recurso `azurerm_managed_lustre_file_system` validando la siguiente condición:
1.  **Presencia del Bloque de Cifrado:** Se verifica la existencia del bloque `encryption_key`. Si este bloque no está definido, el sistema de archivos utiliza por defecto el cifrado gestionado por Azure.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Uso de Claves Gestionadas por la Plataforma (Bloque Ausente)

* **Descripción:** El sistema de archivos Lustre se define sin el bloque de configuración de cifrado por cliente, lo que delega la protección de los datos a las claves por defecto de la plataforma.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_managed_lustre_file_system" "example_insecure" {
      name                   = "insecure-lustre"
      resource_group_name    = "rg-example"
      location               = "West Europe"
      sku_name               = "AMLFS-Durable-Premium-250"
      subnet_id              = azurerm_subnet.example.id
      storage_capacity_in_tb = 48
      
      # El recurso carece del bloque encryption_key
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_managed_lustre_file_system`.

## Recurso Involucrado

* `azurerm_managed_lustre_file_system`

## Solución

Para solucionar este riesgo, defina el bloque `encryption_key` proporcionando la URL de la clave y el ID del Key Vault de origen.

```terraform
resource "azurerm_managed_lustre_file_system" "secure_lustre" {
  name                   = "secure-lustre"
  resource_group_name    = "rg-example"
  location               = "West Europe"
  sku_name               = "AMLFS-Durable-Premium-250"
  subnet_id              = azurerm_subnet.example.id
  storage_capacity_in_tb = 48

  # SOLUCIÓN: Configurar cifrado con CMK
  encryption_key {
    key_url         = azurerm_key_vault_key.example.id
    source_vault_id = azurerm_key_vault.example.id
  }
}
# Regla KICS: Azure PaaS Services Private Endpoint Disabled (Master)

## Descripción General

Esta es una regla consolidada (**Regla Maestra**) diseñada para asegurar que los servicios PaaS críticos de Azure estén protegidos mediante el uso de **Private Endpoints**.

Los Private Endpoints (Puntos de Conexión Privados) son un componente esencial de la seguridad perimetral en Azure. Permiten que los servicios (como bases de datos, almacenamiento o bóvedas de claves) se integren directamente en una Red Virtual (VNet). Al asignar una dirección IP privada del espacio de la VNet al servicio, se elimina la necesidad de exponer dichos recursos a la internet pública, reduciendo drásticamente la superficie de ataque y previniendo la exfiltración de datos.

## Lógica de la Regla

La política analiza de forma exhaustiva los recursos definidos en Terraform buscando una vinculación válida:
1.  **Recursos Objetivo:** La regla monitorea una lista extensa de servicios, incluyendo `azurerm_storage_account`, `azurerm_mssql_server`, `azurerm_cosmosdb_account`, `azurerm_key_vault` y otros servicios de datos y mensajería.
2.  **Validación de Vínculo:** Para cada recurso detectado, busca la existencia de un recurso `azurerm_private_endpoint` que lo referencia a través del atributo `private_connection_resource_id`.
3.  **Resultado:** Si el recurso PaaS existe pero no hay un endpoint privado asociado en el mismo contexto de código, se genera una alerta.

## Limitaciones del Análisis Estático

Es importante notar que esta regla valida la configuración **dentro del mismo archivo o estado de Terraform**. Debido a la naturaleza del análisis estático:
* No puede validar conexiones si el recurso se crea en una suscripción distinta o se gestiona en un estado de Terraform separado.
* Podría generar falsos positivos si el endpoint se define mediante módulos externos cuyas variables no son resueltas por el motor de escaneo.

## Caso de Fallo Detectado

A continuación se describe el escenario principal que esta política detectará.

---

### Caso Único: Recurso PaaS Aislado (Sin Endpoint Privado)

* **Descripción:** Se ha definido un servicio crítico (ej. Azure SQL o Storage Account) pero no se ha aprovisionado el endpoint privado que garantice que el tráfico sea interno a la VNet.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_storage_account" "example_insecure" {
      name                     = "stinsecuredata"
      resource_group_name      = azurerm_resource_group.example.name
      location                 = azurerm_resource_group.example.location
      account_tier             = "Standard"
      account_replication_type = "LRS"

      # El recurso existe pero carece de un azurerm_private_endpoint vinculado
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso PaaS identificado (Storage, SQL, Key Vault, etc.).

## Recursos Involucrados

* `azurerm_private_endpoint`
* Servicios PaaS (Storage, SQL, Cosmos, KeyVault, ACR, ServiceBus, etc.)

## Solución

Para solucionar este hallazgo, debe crear un recurso `azurerm_private_endpoint` y vincularlo al ID del recurso PaaS mediante el bloque `private_service_connection`.

```terraform
resource "azurerm_private_endpoint" "example_secure" {
  name                = "pe-storage"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "psc-storage"
    private_connection_resource_id = azurerm_storage_account.example_insecure.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
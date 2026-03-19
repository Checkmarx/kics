# Regla KICS: Storage Queue Service Logging Disabled

## Descripción General

Esta regla verifica que el **Logging de Almacenamiento** (Storage Analytics Logging) esté habilitado para el servicio de **Colas (Queue Service)** en las cuentas de almacenamiento de Azure.

El registro de auditoría es un componente fundamental de la observabilidad. Permite rastrear la actividad detallada en el plano de datos, capturando quién y cuándo interactuó con los mensajes de la cola. La política valida que se registren las siguientes operaciones:
* **Read (Lectura):** Operaciones como la visualización o extracción de mensajes.
* **Write (Escritura):** Operaciones de inserción o actualización de mensajes.
* **Delete (Borrado):** Operaciones de eliminación de mensajes o vaciado de colas.

Sin esta configuración, las organizaciones pierden la trazabilidad necesaria para investigar comportamientos anómalos o fugas de información a través del servicio de mensajería.

## Lógica de la Regla

La política audita tanto la configuración embebida en la cuenta de almacenamiento como el recurso específico de propiedades:
1.  **Identificación de Atributos:** Busca la presencia de `queue_properties` en el recurso principal o instancias del recurso independiente.
2.  **Validación de Auditoría:** Asegura la existencia del bloque `logging`.
3.  **Verificación de Acciones:** Comprueba que `read`, `write` y `delete` estén configurados explícitamente como `true`.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Logging Embebido Ausente

* **Descripción:** Se definen propiedades de cola en la cuenta de almacenamiento pero no se incluye la configuración de registro.
* **Ubicación de la Alerta:** Bloque `queue_properties` del recurso `azurerm_storage_account`.

---

### Caso 2: Configuración Embebida Incorrecta

* **Descripción:** El bloque de registro existe en la cuenta de almacenamiento pero alguna de las acciones críticas está desactivada.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_storage_account" "fail_logging" {
      # ...
      queue_properties {
        logging {
          read  = false # <-- PROBLEMA
          write = true
          delete = true
          version = "1.0"
        }
      }
    }
    ```
* **Ubicación de la Alerta:** Atributo `logging` del recurso `azurerm_storage_account`.

---

### Caso 3: Recurso Standalone sin Logging

* **Descripción:** Se utiliza el recurso `azurerm_storage_account_queue_properties` pero se omite completamente el bloque de registro.
* **Ubicación de la Alerta:** Recurso `azurerm_storage_account_queue_properties`.

---

### Caso 4: Recurso Standalone con Configuración Incorrecta

* **Descripción:** El recurso independiente de propiedades tiene el bloque de registro, pero con acciones deshabilitadas.
* **Ubicación de la Alerta:** Atributo `logging` del recurso `azurerm_storage_account_queue_properties`.

## Recursos Involucrados

* `azurerm_storage_account`
* `azurerm_storage_account_queue_properties`

## Solución

Habilite el registro para todas las operaciones (`read`, `write`, `delete`) dentro de la configuración del servicio de colas.

```terraform
resource "azurerm_storage_account" "secure_queue" {
  name                     = "stsecurequeue"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  queue_properties {
    logging {
      read                  = true
      write                 = true
      delete                = true
      version               = "1.0"
      retention_policy_days = 30
    }
  }
}
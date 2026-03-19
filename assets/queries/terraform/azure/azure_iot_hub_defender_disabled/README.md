# Regla KICS: Azure IoT Hub Defender Disabled

## Descripción General

Esta regla de KICS verifica que los recursos **Azure IoT Hub** (`azurerm_iothub`) estén protegidos por **Microsoft Defender for IoT**.

Microsoft Defender for IoT proporciona una capa esencial de seguridad para entornos de Internet de las cosas, ofreciendo detección de amenazas en tiempo real y gestión de la postura de seguridad. La falta de esta protección deja a los dispositivos IoT y a la infraestructura central del Hub vulnerables ante ataques dirigidos, movimientos laterales y exfiltración de datos. En Terraform, esta protección se habilita vinculando el IoT Hub con un recurso del tipo `azurerm_iot_security_solution`.

## Lógica de la Regla

La política analiza la configuración de Terraform realizando los siguientes pasos:
1.  **Identificación de Hubs:** Selecciona todos los recursos de tipo `azurerm_iothub`.
2.  **Verificación de Soluciones:** Busca recursos `azurerm_iot_security_solution` en el documento.
3.  **Validación de Vinculación:** Comprueba si el identificador del Hub está presente en la lista `iothub_ids` de alguna solución de seguridad definida, contemplando formatos directos o interpolados.
4.  **Generación de Alerta:** Si un Hub no está referenciado en ninguna solución, se genera un hallazgo de seguridad.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: IoT Hub sin Defender asociado

* **Descripción:** Se define un recurso `azurerm_iothub` pero no se encuentra ningún recurso `azurerm_iot_security_solution` que lo incluya en su lista de IDs protegidos.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_iothub" "fail_hub" {
      name                = "insecure-iothub"
      resource_group_name = azurerm_resource_group.example.name
      location            = azurerm_resource_group.example.location
      
      sku {
        name     = "S1"
        capacity = "1"
      }
    }

    # No existe azurerm_iot_security_solution que referencie a fail_hub
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_iothub`.

## Recurso Involucrado

* `azurerm_iothub`
* `azurerm_iot_security_solution`

## Solución

Para solucionar este riesgo, asegúrese de definir un recurso `azurerm_iot_security_solution` e incluir el ID del IoT Hub en el atributo `iothub_ids`.

```terraform
resource "azurerm_iothub" "example" {
  name                = "secure-iothub"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  
  sku {
    name     = "S1"
    capacity = "1"
  }
}

# SOLUCIÓN: Definir la solución de seguridad y vincular el Hub
resource "azurerm_iot_security_solution" "example" {
  name                = "iot-security-solution"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  display_name        = "Iot Security Solution"
  
  iothub_ids          = [azurerm_iothub.example.id]
}
# Regla KICS: Elastic SAN Public Network Access Enabled

## Descripción General

Esta regla de KICS verifica que los grupos de volúmenes de Azure Elastic SAN (`azurerm_elastic_san_volume_group`) tengan restringido el acceso desde redes públicas.

En la arquitectura de Azure Elastic SAN, la seguridad y el aislamiento de red no se gestionan en el recurso raíz de la SAN, sino a nivel de **Volume Group**. Para garantizar que los volúmenes de datos no sean accesibles desde Internet, es imprescindible definir el bloque `network_rule`. La sola presencia de este bloque activa una política de denegación implícita para cualquier tráfico que no provenga de las subredes autorizadas, asegurando que la infraestructura solo sea accesible a través de la red privada.

## Lógica de la Regla

La política audita el recurso `azurerm_elastic_san_volume_group` analizando la siguiente condición:
1.  **Existencia del Bloque de Red:** Se verifica la presencia del bloque `network_rule`. Si este bloque no está definido, el grupo de volúmenes carece de restricciones perimetrales, permitiendo potencialmente el acceso público.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Configuración de Red Ausente

* **Descripción:** El grupo de volúmenes se define sin el bloque `network_rule`, lo que significa que no se están aplicando reglas de filtrado de IP o de red virtual para proteger los datos.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_elastic_san_volume_group" "example_insecure" {
      name           = "insecure-vg"
      elastic_san_id = azurerm_elastic_san.example.id
      
      # El recurso carece del bloque network_rule, 
      # quedando expuesto a redes públicas.
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_elastic_san_volume_group`.

## Recurso Involucrado

* `azurerm_elastic_san_volume_group`

## Solución

Para solucionar este riesgo de seguridad, defina el bloque `network_rule` vinculándolo a una subred autorizada mediante el atributo `subnet_id`.

```terraform
resource "azurerm_elastic_san_volume_group" "secure_vg" {
  name           = "secure-volume-group"
  elastic_san_id = azurerm_elastic_san.example.id
  
  # SOLUCIÓN: Definir reglas de red para denegar el acceso público
  network_rule {
    subnet_id = azurerm_subnet.example.id
  }
}
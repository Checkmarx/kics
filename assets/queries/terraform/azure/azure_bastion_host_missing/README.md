# Regla KICS: Azure Bastion Host Missing

## Descripción General

Esta regla verifica que, si se están desplegando redes virtuales (`azurerm_virtual_network`), exista al menos un recurso **Azure Bastion Host** (`azurerm_bastion_host`) definido en la configuración.

Azure Bastion es un servicio PaaS que se aprovisiona dentro de una red virtual. Proporciona conectividad RDP y SSH segura directamente desde el portal de Azure a través de SSL. Esto elimina la necesidad de exponer puertos administrativos (22, 3389) a Internet o gestionar complejas VPNs y Jumpboxes para tareas de mantenimiento, reduciendo drásticamente la superficie de ataque.

## Lógica de la Regla

La política realiza un análisis de presencia de recursos a nivel de documento:
1.  Verifica si existe algún recurso `azurerm_virtual_network`.
2.  Si existen redes, busca si hay algún recurso `azurerm_bastion_host` definido en el mismo archivo/contexto.
3.  Si existen redes pero no se encuentra ningún Bastion Host, se genera una alerta sobre la red virtual.

## Casos de Fallo Detectados

### Caso 1: VNet sin Bastion Host

* **Descripción:** Se define infraestructura de red, pero no se incluye el servicio de Bastion, lo que sugiere que el acceso administrativo podría estar realizándose de forma insegura mediante IPs públicas directas o puertos abiertos en los grupos de seguridad (NSG).
* **Ubicación de la Alerta:** Sobre el recurso `azurerm_virtual_network`.

## Recurso Involucrado

* `azurerm_virtual_network`
* `azurerm_bastion_host`

## Solución

Para solucionar el problema, define un recurso `azurerm_bastion_host` y asegúrate de crear la subred obligatoria llamada `AzureBastionSubnet`.

```terraform
resource "azurerm_subnet" "example_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_bastion_host" "example" {
  name                = "production-bastion"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.example_bastion.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
}
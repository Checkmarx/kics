# KICS Rule: Azure Bastion Host Missing

## General Description

This rule verifies that, if virtual networks (`azurerm_virtual_network`) are being deployed, at least one **Azure Bastion Host** resource (`azurerm_bastion_host`) is defined in the configuration.

Azure Bastion is a PaaS service provisioned within a virtual network. It provides secure RDP and SSH connectivity directly from the Azure portal over SSL. This eliminates the need to expose administrative ports (22, 3389) to the Internet or manage complex VPNs and Jumpboxes for maintenance tasks, drastically reducing the attack surface.

## Rule Logic

The policy performs a resource presence analysis at the document level:
1.  Checks whether any `azurerm_virtual_network` resource exists.
2.  If networks exist, looks for any `azurerm_bastion_host` resource defined in the same file/context.
3.  If networks exist but no Bastion Host is found, an alert is generated on the virtual network.

## Detected Failure Cases

### Case 1: VNet without Bastion Host

* **Description:** Network infrastructure is defined, but the Bastion service is not included, suggesting that administrative access may be performed insecurely via direct public IPs or open ports in security groups (NSG).
* **Alert Location:** On the `azurerm_virtual_network` resource.

## Involved Resource

* `azurerm_virtual_network`
* `azurerm_bastion_host`

## Solution

To fix the issue, define an `azurerm_bastion_host` resource and make sure to create the mandatory subnet named `AzureBastionSubnet`.

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

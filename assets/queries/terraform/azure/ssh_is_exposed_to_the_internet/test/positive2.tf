resource "azurerm_network_security_rule" "positive2-1" {
 name            = "positive2-1"
 priority          = 107
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "Tcp"
 source_port_range      = "*"
 destination_port_ranges   = ["21-23", "23000"]
 source_address_prefix    = "internet"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive2-2" {
 name            = "positive2-2"
 priority          = 108
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "Tcp"
 source_port_range      = "*"
 destination_port_ranges   = ["21", "22", "23"]
 source_address_prefix    = "any"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive2-3" {
 name            = "positive2-3"
 priority          = 109
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "*"
 source_port_range      = "*"
 destination_port_ranges   = ["3387", "21-23", "25"]
 source_address_prefix    = "0/0"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive2-4" {
 name            = "positive2-4"
 priority          = 100
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "*"
 source_port_range      = "*"
 destination_port_ranges   = ["200-300", "2000-4430", "21-23", "123"]
 source_address_prefix    = "internet"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_group" "positive5-8" {
  name                = "group_example"
  location            = azurerm_resource_group.cli-2-11.location
  resource_group_name = azurerm_resource_group.cli-2-11.name

  security_rule {
    name                       = "positive2-5"
    priority                   = 107
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["21-23", "23000"]
    source_address_prefix      = "internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "positive2-6"
    priority                   = 108
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["21", "22", "23"]
    source_address_prefix      = "any"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "positive2-7"
    priority                   = 109
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["3387", "21-23", "25"]
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "positive2-8"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["200-300", "2000-4430", "21-23", "123"]
    source_address_prefix      = "internet"
    destination_address_prefix = "*"
  }
}

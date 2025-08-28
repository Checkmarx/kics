resource "azurerm_network_security_rule" "positive2-1" {
 name            = "positive2-1"
 priority          = 107
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "Tcp"
 source_port_range      = "*"
 destination_port_ranges   = ["3388-3390", "23000"]
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
 destination_port_ranges   = ["3388", "3389", "3390"]
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
 destination_port_ranges   = ["3387", "3388-3390", "3391"]
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
 destination_port_ranges   = ["111-211", "2000-4430", "1-2", "3"]
 source_address_prefix    = "internet"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_group" "cli-2-11" {
  name                = "cli-2-11"
  location            = azurerm_resource_group.cli-2-11.location
  resource_group_name = azurerm_resource_group.cli-2-11.name

  security_rule {
    name                       = "positive2-5"
    priority                   = 107
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["3388-3390", "23000"]
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
    destination_port_ranges    = ["3388", "3389", "3390"]
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
    destination_port_ranges    = ["3387", "3388-3390", "3391"]
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
    destination_port_ranges    = ["111-211", "2000-4430", "1-2", "3"]
    source_address_prefix      = "internet"
    destination_address_prefix = "*"
  }
}

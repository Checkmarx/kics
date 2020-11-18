resource "azurerm_network_security_rule" "example1" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "8140"
     source_address_prefix       = "/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example2" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "8140-8151"
     source_address_prefix       = "1.1.1.1/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example3" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_range      = "8138-8140"
     source_address_prefix       = "/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example4" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_range      = "8140"
     source_address_prefix       = "0.0.0.0/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example5" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "8140,8362"
     source_address_prefix       = "34.15.11.3/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example6" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "8140"
     source_address_prefix       = "/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example7" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "8139-8181, 8211"
     source_address_prefix       = "10.0.0.0/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example8" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "8131, 8140, 16282"
     source_address_prefix       = "12.12.12.12/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example9" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_range      = "8129, 8140-8141,16280"
     source_address_prefix       = "/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example10" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_range      = "16280-16380, 8135-8153, 1-2, 3"
     source_address_prefix       = "1.2.3.4/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

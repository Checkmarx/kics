resource "azurerm_network_security_rule" "positive1" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "22"
     source_address_prefix       = "*"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "positive2" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "22-23"
     source_address_prefix       = "*"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "positive3" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "21-53"
     source_address_prefix       = "*"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "positive4" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "22"
     source_address_prefix       = "0.0.0.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "positive5" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "22,24"
     source_address_prefix       = "34.15.11.3/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "positive6" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "22"
     source_address_prefix       = "/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "positive7" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "21-24, 230"
     source_address_prefix       = "internet"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "positive8" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "21, 22 , 24 "
     source_address_prefix       = "any"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "positive9" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_range      = "21, 22-23,2250"
     source_address_prefix       = "/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "positive10" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_range      = "111-211, 20-30, 1-2 , 3"
     source_address_prefix       = "internet"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource azurerm_network_security_group "positive11-20" {
  location            = var.location
  name                = "group_example"
  resource_group_name = azurerm_resource_group.example.name

     security_rule {
          name                        = "positive11"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "22"
          source_address_prefix       = "*"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "positive12"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "22-23"
          source_address_prefix       = "*"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "positive13"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "21-53"
          source_address_prefix       = "*"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "positive14"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "22"
          source_address_prefix       = "0.0.0.0"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "positive15"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "22,24"
          source_address_prefix       = "34.15.11.3/0"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "positive16"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "22"
          source_address_prefix       = "/0"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "positive17"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "21-24, 230"
          source_address_prefix       = "internet"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "positive18"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "21, 22 , 24 "
          source_address_prefix       = "any"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "positive19"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "*"
          source_port_range           = "*"
          destination_port_range      = "21, 22-23,2250"
          source_address_prefix       = "/0"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "positive20"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "*"
          source_port_range           = "*"
          destination_port_range      = "111-211, 20-30, 1-2 , 3"
          source_address_prefix       = "internet"
          destination_address_prefix  = "*"
     }
}

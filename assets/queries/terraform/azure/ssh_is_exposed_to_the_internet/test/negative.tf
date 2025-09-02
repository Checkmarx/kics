resource "azurerm_network_security_rule" "negative1" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Deny"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "22"
     source_address_prefix       = "*"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative2" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "UDP"
     source_port_range           = "*"
     destination_port_range      = "20-50"
     source_address_prefix       = "*"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}


resource "azurerm_network_security_rule" "negative3" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "30-50"
     source_address_prefix       = "0.0.0.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}


resource "azurerm_network_security_rule" "negative4" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "20-50"
     source_address_prefix       = "192.168.0.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}


resource "azurerm_network_security_rule" "negative5" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "22"
     source_address_prefix       = "/1"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative6" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_range      = "21"
     source_address_prefix       = "/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}


resource "azurerm_network_security_rule" "negative7" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "UDP"
     source_port_range           = "*"
     destination_port_range      = "22"
     source_address_prefix       = "internet"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}


resource "azurerm_network_security_rule" "negative8" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_range      = "21, 23,10-20"
     source_address_prefix       = "any"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}


resource "azurerm_network_security_rule" "negative9" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "UDP"
     source_port_range           = "*"
     destination_port_range      = "22"
     source_address_prefix       = "/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative10" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "22 ,  23"
     source_address_prefix       = "0.0.1.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative11" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "220,230"
     source_address_prefix       = "0.0.0.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}


resource azurerm_network_security_group "negative12-22" {
  location            = var.location
  name                = "terragoat-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
          name                        = "negative12"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Deny"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "22"
          source_address_prefix       = "*"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "negative13"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "UDP"
          source_port_range           = "*"
          destination_port_range      = "20-50"
          source_address_prefix       = "*"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "negative14"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "30-50"
          source_address_prefix       = "0.0.0.0"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "negative15"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "20-50"
          source_address_prefix       = "192.168.0.0"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "negative16"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "22"
          source_address_prefix       = "/1"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "negative17"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "*"
          source_port_range           = "*"
          destination_port_range      = "21"
          source_address_prefix       = "/0"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "negative18"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "UDP"
          source_port_range           = "*"
          destination_port_range      = "22"
          source_address_prefix       = "internet"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "negative19"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "*"
          source_port_range           = "*"
          destination_port_range      = "21, 23,10-20"
          source_address_prefix       = "any"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "negative20"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "UDP"
          source_port_range           = "*"
          destination_port_range      = "22"
          source_address_prefix       = "/0"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "negative21"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "22 ,  23"
          source_address_prefix       = "0.0.1.0"
          destination_address_prefix  = "*"
     }

     security_rule {
          name                        = "negative22"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "220,230"
          source_address_prefix       = "0.0.0.0"
          destination_address_prefix  = "*"
     }
}


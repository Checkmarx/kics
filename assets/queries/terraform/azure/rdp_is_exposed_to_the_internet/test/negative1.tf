resource "azurerm_network_security_rule" "negative1" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Deny"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "3389"
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
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "4030-5100"
     source_address_prefix       = "0.0.0.0"
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
     destination_port_range      = "2100-5300"
     source_address_prefix       = "192.168.0.0"
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
     destination_port_range      = "3389"
     source_address_prefix       = "/1"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative5" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_range      = "3388"
     source_address_prefix       = "/0"
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
     destination_port_range      = "3388, 3390,1000-2000"
     source_address_prefix       = "any"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative7" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "3389 ,  3390"
     source_address_prefix       = "0.0.1.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative8" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_range      = "338,389"
     source_address_prefix       = "0.0.0.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource azurerm_network_security_group "negative9-17" {
  location            = var.location
  name                = "terragoat-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name

     security_rule {
          name                        = "negative9"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Deny"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "3389"
          source_address_prefix       = "*"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative10"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "4030-5100"
          source_address_prefix       = "0.0.0.0"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }


     security_rule {
          name                        = "negative11"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "2100-5300"
          source_address_prefix       = "192.168.0.0"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }


     security_rule {
          name                        = "negative12"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "3389"
          source_address_prefix       = "/1"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative13"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "*"
          source_port_range           = "*"
          destination_port_range      = "3388"
          source_address_prefix       = "/0"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative14"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "*"
          source_port_range           = "*"
          destination_port_range      = "3388, 3390,1000-2000"
          source_address_prefix       = "any"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative15"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "3389 ,  3390"
          source_address_prefix       = "0.0.1.0"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative16"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_range      = "338,389"
          source_address_prefix       = "0.0.0.0"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative17"
          priority                    = 114
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "Udp"
          source_port_range           = "*"
          destination_port_range      = "1000-1200"
          source_address_prefix       = "*"
          destination_address_prefix  = "*"
     }
}

resource "azurerm_network_security_rule" "negative18" {
     name                        = "negative18"
     priority                    = 114
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "Udp"
     source_port_range           = "*"
     destination_port_range      = "1000-2000"
     source_address_prefix       = "*"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}
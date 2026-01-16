resource "azurerm_network_security_rule" "negative2-1" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Deny"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_ranges     = ["3388", "3390", "1000-2000"]
     source_address_prefix       = "*"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative2-2" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_ranges     = ["3387", "3391", "2000-3000"]
     source_address_prefix       = "0.0.0.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}


resource "azurerm_network_security_rule" "negative2-3" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_ranges     = ["20-30", "53", "123"]
     source_address_prefix       = "192.168.0.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}


resource "azurerm_network_security_rule" "negative2-4" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_ranges     = ["22"]
     source_address_prefix       = "/1"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative2-5" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_ranges     = ["2100-2300", "23000", "3385"]
     source_address_prefix       = "/0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative2-6" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "*"
     source_port_range           = "*"
     destination_port_ranges     = ["3388","3390","1000-2000"]
     source_address_prefix       = "any"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative2-7" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_ranges     = ["2200","3390"]
     source_address_prefix       = "0.0.1.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "negative2-8" {
     name                        = "example"
     priority                    = 100
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "TCP"
     source_port_range           = "*"
     destination_port_ranges     = ["338","389"]
     source_address_prefix       = "0.0.0.0"
     destination_address_prefix  = "*"
     resource_group_name         = azurerm_resource_group.example.name
     network_security_group_name = azurerm_network_security_group.example.name
}

resource azurerm_network_security_group "negative2-9-17" {
  location            = var.location
  name                = "terragoat-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name

     security_rule {
          name                        = "negative2-9"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Deny"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_ranges     = ["3388", "3390", "1000-2000"]
          source_address_prefix       = "*"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative2-10"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_ranges     = ["3387", "3391", "2000-3000"]
          source_address_prefix       = "0.0.0.0"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }


     security_rule {
          name                        = "negative2-11"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_ranges     = ["20-30", "53", "123"]
          source_address_prefix       = "192.168.0.0"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }


     security_rule {
          name                        = "negative2-12"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_ranges     = ["22"]
          source_address_prefix       = "/1"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative2-13"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "*"
          source_port_range           = "*"
          destination_port_ranges     = ["21-23", "23000", "3385"]
          source_address_prefix       = "/0"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative2-14"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "*"
          source_port_range           = "*"
          destination_port_ranges     = ["3388","3390","1000-2000"]
          source_address_prefix       = "any"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative2-15"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_ranges     = ["22","3390"]
          source_address_prefix       = "0.0.1.0"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }

     security_rule {
          name                        = "negative2-16"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "TCP"
          source_port_range           = "*"
          destination_port_ranges     = ["338","389"]
          source_address_prefix       = "0.0.0.0"
          destination_address_prefix  = "*"
          resource_group_name         = azurerm_resource_group.example.name
          network_security_group_name = azurerm_network_security_group.example.name
     }
}

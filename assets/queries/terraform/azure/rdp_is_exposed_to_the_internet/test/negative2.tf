resource "azurerm_network_security_rule" "neagtive2-1" {
  name                        = "neagtive2-1"
  priority                    = 108
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["3388", "3390", "1000-2000"]
  source_address_prefix       = "any"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.cli-2-11.name
  network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource azurerm_network_security_group "negative2-2" {
  location            = var.location
  name                = "terragoat-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
        name                        = "neagtive2-2"
        priority                    = 108
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "*"
        source_port_range           = "*"
        destination_port_ranges     = ["3388", "3390", "1000-2000"]
        source_address_prefix       = "any"
        destination_address_prefix  = "*"
    }   
}
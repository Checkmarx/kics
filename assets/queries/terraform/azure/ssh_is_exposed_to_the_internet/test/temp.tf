resource "azurerm_network_security_rule" "positive1" {
 name            = "positive1"
 priority          = 101
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "Tcp"
 source_port_range      = "*"
 destination_port_range   = "22"
 source_address_prefix    = "*"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive2" {
 name            = "positive2"
 priority          = 102
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "Tcp"
 source_port_range      = "*"
 destination_port_range   = "22-23"
 source_address_prefix    = "*"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive3" {
 name            = "positive3"
 priority          = 103
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "Tcp"
 source_port_range      = "*"
 destination_port_range   = "21-22"
 source_address_prefix    = "*"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive4" {
 name            = "positive4"
 priority          = 104
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "Tcp"
 source_port_range      = "*"
 destination_port_range   = "22"
 source_address_prefix    = "0.0.0.0/0"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive5" {
 name            = "positive5"
 priority          = 105
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "Tcp"
 source_port_range      = "*"
 destination_port_range   = "21-25"
 source_address_prefix    = "/0"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive6" {
 name            = "positive6"
 priority          = 106
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "Tcp"
 source_port_range      = "*"
 destination_port_range   = "22"
 source_address_prefix    = "0.0.0.0"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive7" {
 name            = "positive7"
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

resource "azurerm_network_security_rule" "positive8" {
 name            = "positive8"
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

resource "azurerm_network_security_rule" "positive9" {
 name            = "positive9"
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

resource "azurerm_network_security_rule" "positive10" {
 name            = "positive10"
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

resource "azurerm_network_security_rule" "positive11" {
 name            = "positive11"
 priority          = 111
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "*"
 source_port_range      = "*"
 destination_port_range   = "22"
 source_address_prefix    = "*"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive12" {
 name            = "positive12"
 priority          = 112
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "*"
 source_port_range      = "*"
 destination_port_range   = "22"
 source_address_prefix    = "0.0.0.0"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}

resource "azurerm_network_security_rule" "positive13" {
 name            = "positive13"
 priority          = 113
 direction          = "Inbound"
 access           = "Allow"
 protocol          = "*"
 source_port_range      = "*"
 destination_port_range   = "22"
 source_address_prefix    = "/0"
 destination_address_prefix = "*"
 resource_group_name     = azurerm_resource_group.cli-2-11.name
 network_security_group_name = azurerm_network_security_group.cli-2-11.name
}



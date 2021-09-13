package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	network := input.document[i].resource.azurerm_network_interface[name].ip_configuration

	common_lib.valid_key(network, "public_ip_address_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_network_interface[%s].ip_configuration.public_ip_address_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_network_interface[%s].ip_configuration.public_ip_address_id' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_network_interface[%s].ip_configuration.public_ip_address_id' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_network_interface", name, "ip_configuration", "public_ip_address_id"], []),
	}
}

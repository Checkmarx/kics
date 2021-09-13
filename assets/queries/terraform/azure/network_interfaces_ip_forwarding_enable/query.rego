package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	ip := input.document[i].resource.azurerm_network_interface[name]

	not common_lib.valid_key(ip, "enable_ip_forwarding")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_network_interface[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_network_interface[%s].enable_ip_forwarding' is defined and set to false", [name]),
		"keyActualValue": sprintf("'azurerm_network_interface[%s].enable_ip_forwarding' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_network_interface", name], []),
	}
}

CxPolicy[result] {
	ip := input.document[i].resource.azurerm_network_interface[name]

	ip.enable_ip_forwarding == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_network_interface[%s].enable_ip_forwarding", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_network_interface[%s].enable_ip_forwarding' is set to false", [name]),
		"keyActualValue": sprintf("'azurerm_network_interface[%s].enable_ip_forwarding' is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_network_interface", name, "enable_ip_forwarding"], []),
	}
}

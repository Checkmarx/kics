package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	network := document.resource.azurerm_network_interface[name].ip_configuration

	common_lib.valid_key(network, "public_ip_address_id")

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_network_interface",
		"resourceName": tf_lib.get_resource_name(document.resource.azurerm_network_interface[name], name),
		"searchKey": sprintf("azurerm_network_interface[%s].ip_configuration.public_ip_address_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_network_interface[%s].ip_configuration.public_ip_address_id' should be undefined", [name]),
		"keyActualValue": sprintf("'azurerm_network_interface[%s].ip_configuration.public_ip_address_id' is defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_network_interface", name, "ip_configuration", "public_ip_address_id"], []),
	}
}

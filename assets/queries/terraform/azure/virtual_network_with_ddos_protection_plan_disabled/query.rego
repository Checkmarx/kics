package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_virtual_network[name]

	not common_lib.valid_key(resource, "ddos_protection_plan")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_virtual_network[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_virtual_network[%s].ddos_protection_plan' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_virtual_network[%s].ddos_protection_plan' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_virtual_network", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_virtual_network[name]

	resource.ddos_protection_plan.enable == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_virtual_network[%s].ddos_protection_plan.enable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_virtual_network[%s].ddos_protection_plan.enable' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_virtual_network[%s].ddos_protection_plan.enable' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_virtual_network", name, "ddos_protection_plan", "enable"], []),
	}
}

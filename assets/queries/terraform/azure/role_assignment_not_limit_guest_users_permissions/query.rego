package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	role_assign := input.document[i].resource.azurerm_role_assignment[name]
	role_assign.role_definition_name == "Guest"

	ref := split(role_assign.role_definition_id, ".")
	role_definition := input.document[_].resource.azurerm_role_definition[ref[1]]

	not restricted(role_definition)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_role_assignment",
		"resourceName": tf_lib.get_resource_name(role_assign, name),
		"searchKey": sprintf("azurerm_role_assignment[%s].role_definition_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_role_assignment[%s].role_definition_id limits guest user permissions", [name]),
		"keyActualValue": sprintf("azurerm_role_assignment[%s].role_definition_id does not limit guest user permissions", [name]),
	}
}

restricted(resource) {
	count(resource.permissions.not_actions) != 0
}

package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name]

	results := get_results(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_recovery_services_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].immutability' should be set and enabled", [name]),
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results {
	not common_lib.valid_key(resource, "immutability")
	results := {
		"searchKey": sprintf("azurerm_recovery_services_vault[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].immutability' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name], [])
	}

} else = results {
	resource.immutability == "Disabled"
	results := {
		"searchKey": sprintf("azurerm_recovery_services_vault[%s].immutability", [name]),
		"issueType": "IncorrectValue",
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].immutability' is set to 'Disabled'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name, "immutability"], [])
	}
}

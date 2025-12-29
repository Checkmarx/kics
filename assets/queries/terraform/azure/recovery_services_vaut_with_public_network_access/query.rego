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
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].public_network_access_enabled' should be defined and set to false", [name]),
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results {
	not common_lib.valid_key(resource, "public_network_access_enabled")
	results := {
		"searchKey": sprintf("azurerm_recovery_services_vault[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].public_network_access_enabled' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name], [])
	}

} else = results {
	resource.public_network_access_enabled == true
	results := {
		"searchKey": sprintf("azurerm_recovery_services_vault[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].public_network_access_enabled' is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name, "public_network_access_enabled"], [])
	}
}

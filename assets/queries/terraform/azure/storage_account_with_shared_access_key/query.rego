package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]

	results := get_results(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s].shared_access_key_enabled' should be defined and set to false", [name]),
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results {
	not common_lib.valid_key(resource, "shared_access_key_enabled")
	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].shared_access_key_enabled' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name], [])
	}
} else = results {
	resource.shared_access_key_enabled != false
	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s].shared_access_key_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].shared_access_key_enabled' is set to '%s'", [name, resource.shared_access_key_enabled]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name, "shared_access_key_enabled"], [])
	}
}

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
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s].share_properties.retention_policy' should be defined and not null", [name]),
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results {
	not common_lib.valid_key(resource, "share_properties")
	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s]", [name]),
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].share_properties' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name], [])
	}
} else = results {
	not common_lib.valid_key(resource.share_properties, "retention_policy")
	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s].share_properties", [name]),
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].share_properties.retention_policy' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name, "share_properties"], [])
	}
}

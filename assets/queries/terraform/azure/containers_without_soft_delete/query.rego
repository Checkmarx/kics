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
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results {
	not common_lib.valid_key(resource, "blob_properties")
	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s].blob_properties.container_delete_retention_policy' should be defined and not null", [name]),
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].blob_properties' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name], [])
	}
} else = results {
	not common_lib.valid_key(resource.blob_properties, "container_delete_retention_policy")
	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s].blob_properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s].blob_properties.container_delete_retention_policy' should be defined and not null", [name]),
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].blob_properties.container_delete_retention_policy' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name, "blob_properties"], [])
	}
} else = results {
	resource.blob_properties.container_delete_retention_policy.days < 7
	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s].blob_properties.container_delete_retention_policy.days", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s].blob_properties.container_delete_retention_policy.days' should be set to a value higher than '6'", [name]),
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].blob_properties.container_delete_retention_policy' is set to '%d'", [name, resource.blob_properties.container_delete_retention_policy.days]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name, "blob_properties", "container_delete_retention_policy", "days"], [])
	}
}

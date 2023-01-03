package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_cosmosdb_account[name]

	not resource.ip_range_filter

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cosmosdb_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_cosmosdb_account[%s].ip_range_filter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_cosmosdb_account[%s].ip_range_filter' should be set", [name]),
		"keyActualValue": sprintf("'azurerm_cosmosdb_account[%s].ip_range_filter' is undefined", [name]),
	}
}

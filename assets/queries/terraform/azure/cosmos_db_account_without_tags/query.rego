package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_cosmosdb_account[name]
	not resource.tags

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cosmosdb_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_cosmosdb_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cosmosdb_account[%s].tags should be defined'", [name]),
		"keyActualValue": sprintf("azurerm_cosmosdb_account[%s].tags is undefined'", [name]),
	}
}

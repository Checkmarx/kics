package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azurerm_cosmosdb_account[name]
	not resource.tags

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_cosmosdb_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_cosmosdb_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cosmosdb_account[%s].tags should be defined'", [name]),
		"keyActualValue": sprintf("azurerm_cosmosdb_account[%s].tags is undefined'", [name]),
	}
}

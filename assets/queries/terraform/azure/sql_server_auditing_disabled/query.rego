package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_server[name]

	not resource.extended_auditing_policy

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_sql_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_sql_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_sql_server.%s.extended_auditing_policy' should exist", [name]),
		"keyActualValue": sprintf("'azurerm_sql_server.%s.extended_auditing_policy' does not exist", [name]),
	}
}

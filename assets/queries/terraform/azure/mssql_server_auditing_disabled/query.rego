package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource
	
	server:= resource.azurerm_mssql_server[name]
	
	not resource.azurerm_mssql_server_extended_auditing_policy[name]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_server",
		"resourceName": tf_lib.get_resource_name(server, name),
		"searchKey": sprintf("azurerm_mssql_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mssql_server[%s].extended_auditing_policy' resource should exist", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server[%s].extended_auditing_policy' resource does not exist", [name]),
	}
}

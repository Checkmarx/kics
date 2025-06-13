package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource
	
	server := resource.azurerm_mssql_server[name]
	
	not resource.azurerm_mssql_server_extended_auditing_policy

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

CxPolicy[result] {
	resource := input.document[i].resource

	server := resource.azurerm_mssql_server[server_name]

	auditing_policy = resource.azurerm_mssql_server_extended_auditing_policy[policy_name]
	auditing_policy.server_id != sprintf("${azurerm_mssql_server.%s.id}", [server_name])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_server_extended_auditing_policy",
		"resourceName": tf_lib.get_resource_name(auditing_policy, policy_name),
		"searchKey": sprintf("azurerm_mssql_server_extended_auditing_policy[%s].server_id", [policy_name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mssql_server_extended_auditing_policy[%s].server_id' should be set to a valid 'azurerm_mssql_server' id", [policy_name]),
		"keyActualValue": sprintf("'azurerm_mssql_server_extended_auditing_policy[%s].server_id' is not set to a valid 'azurerm_mssql_server' id", [policy_name]),
	}
}
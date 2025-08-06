package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	server_resource := input.document[i].resource
	server := server_resource.azurerm_mssql_server[server_name]

	server_id := sprintf("${azurerm_mssql_server.%s.id}", [server_name])
	audited_servers := {policy.server_id | policy := input.document[_].resource.azurerm_mssql_server_extended_auditing_policy[_]}
	not common_lib.inArray(audited_servers, server_id)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_server",
		"resourceName": tf_lib.get_resource_name(server, server_name),
		"searchKey": sprintf("azurerm_mssql_server[%s]", [server_name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mssql_server[%s]' resource should have a 'azurerm_mssql_server_extended_auditing_policy' resource associated", [server_name]),
		"keyActualValue": sprintf("'azurerm_mssql_server[%s]' resource does not have a 'azurerm_mssql_server_extended_auditing_policy' resource associated", [server_name]),
	}
}

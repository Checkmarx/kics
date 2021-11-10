package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_mssql_server[name]

	not common_lib.valid_key(resource, "public_network_access_enabled")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("azurerm_mssql_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mssql_server[%s].public_network_access_enabled' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server[%s].public_network_access_enabled' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name], []),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_mssql_server[name]

	resource.public_network_access_enabled == true

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("azurerm_mssql_server[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mssql_server[%s].public_network_access_enabled' is set to false", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server[%s].public_network_access_enabled' is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name, "public_network_access_enabled"], []),
	}
}

package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_mysql_server[name]

	not common_lib.valid_key(resource, "public_network_access_enabled")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("azurerm_mysql_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mysql_server[%s].public_network_access_enabled' is defined", [name]),
		"keyActualValue": sprintf("'azurerm_mysql_server[%s].public_network_access_enabled' is undefined", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_mysql_server[name]

	resource.public_network_access_enabled == true

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("azurerm_mysql_server[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mysql_server[%s].public_network_access_enabled' is set to false", [name]),
		"keyActualValue": sprintf("'azurerm_mysql_server[%s].public_network_access_enabled' is set to true", [name]),
	}
}

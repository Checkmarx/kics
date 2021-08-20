package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	mariadbServer := input.document[i].resource.azurerm_mariadb_server[name]

	not common_lib.valid_key(mariadbServer, "public_network_access_enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_mariadb_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mariadb_server[%s].public_network_access_enabled' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_mariadb_server[%s].public_network_access_enabled' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	mariadbServer := input.document[i].resource.azurerm_mariadb_server[name]

	mariadbServer.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_mariadb_server[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mariadb_server[%s].public_network_access_enabled.enabled' is set to false", [name]),
		"keyActualValue": sprintf("'azurerm_mariadb_server[%s].public_network_access_enabled.enabled' is not set to false", [name]),
	}
}

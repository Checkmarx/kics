package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	mariadbServer := input.document[i].resource.azurerm_mariadb_server[name]

	not common_lib.valid_key(mariadbServer, "public_network_access_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mariadb_server",
		"resourceName": tf_lib.get_resource_name(mariadbServer, name),
		"searchKey": sprintf("azurerm_mariadb_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mariadb_server[%s].public_network_access_enabled' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_mariadb_server[%s].public_network_access_enabled' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_mariadb_server" ,name], []),
		"remediation": "public_network_access_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	mariadbServer := input.document[i].resource.azurerm_mariadb_server[name]

	mariadbServer.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mariadb_server",
		"resourceName": tf_lib.get_resource_name(mariadbServer, name),
		"searchKey": sprintf("azurerm_mariadb_server[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mariadb_server[%s].public_network_access_enabled.enabled' should be set to false", [name]),
		"keyActualValue": sprintf("'azurerm_mariadb_server[%s].public_network_access_enabled.enabled' is not set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mariadb_server", name, "public_network_access_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}

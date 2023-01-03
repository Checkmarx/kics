package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	mdb := input.document[i].resource.azurerm_mariadb_server[name]

	not common_lib.valid_key(mdb, "geo_redundant_backup_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mariadb_server",
		"resourceName": tf_lib.get_resource_name(mdb, name),
		"searchKey": sprintf("azurerm_mariadb_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mariadb_server[%s].geo_redundant_backup_enabled' should be defined and set to true", [name]),
		"keyActualValue": sprintf("'azurerm_mariadb_server[%s].geo_redundant_backup_enabled' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mariadb_server", name], []),
		"remediation": "geo_redundant_backup_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	mdb := input.document[i].resource.azurerm_mariadb_server[name]

	mdb.geo_redundant_backup_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mariadb_server",
		"resourceName": tf_lib.get_resource_name(mdb, name),
		"searchKey": sprintf("azurerm_mariadb_server[%s].geo_redundant_backup_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mariadb_server[%s].geo_redundant_backup_enabled' should be set to true", [name]),
		"keyActualValue": sprintf("'azurerm_mariadb_server[%s].geo_redundant_backup_enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mariadb_server", name, "geo_redundant_backup_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	mdb := input.document[i].resource.azurerm_mariadb_server[name]

	not common_lib.valid_key(mdb, "geo_redundant_backup_enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_mariadb_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mariadb_server[%s].geo_redundant_backup_enabled' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_mariadb_server[%s].geo_redundant_backup_enabled' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mariadb_server", name], []),
	}
}

CxPolicy[result] {
	mdb := input.document[i].resource.azurerm_mariadb_server[name]

	mdb.geo_redundant_backup_enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_mariadb_server[%s].geo_redundant_backup_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mariadb_server[%s].geo_redundant_backup_enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_mariadb_server[%s].geo_redundant_backup_enabled' is not set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mariadb_server", name, "geo_redundant_backup_enabled"], []),
	}
}

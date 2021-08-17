package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_server[var0]
	not common_lib.valid_key(resource, "geo_redundant_backup_enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_postgresql_server[%s]", [var0]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' is set", [var0]),
		"keyActualValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' is undefined", [var0]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_server[var0]
	resource.geo_redundant_backup_enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_postgresql_server[%s].geo_redundant_backup_enabled", [var0]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' is true", [var0]),
		"keyActualValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' is false", [var0]),
	}
}

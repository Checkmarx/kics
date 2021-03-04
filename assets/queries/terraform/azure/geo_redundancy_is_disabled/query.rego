package Cx


CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_server[var0]
	object.get(resource,"geo_redundant_backup_enabled","undefined") == "undefined"

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
	object.get(resource,"geo_redundant_backup_enabled","undefined") != "undefined"

    not resource.geo_redundant_backup_enabled

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_postgresql_server[%s].geo_redundant_backup_enabled", [var0]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' is true", [var0]),
		"keyActualValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' is false", [var0]),
	}
}

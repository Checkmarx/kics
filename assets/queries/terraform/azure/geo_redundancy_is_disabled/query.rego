package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_server[var0]
	not common_lib.valid_key(resource, "geo_redundant_backup_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_server",
		"resourceName": tf_lib.get_resource_name(resource, var0),
		"searchKey": sprintf("azurerm_postgresql_server[%s]", [var0]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' should be set", [var0]),
		"keyActualValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' is undefined", [var0]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_postgresql_server" ,var0], []),
		"remediation": "geo_redundant_backup_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_server[var0]
	resource.geo_redundant_backup_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_server",
		"resourceName": tf_lib.get_resource_name(resource, var0),
		"searchKey": sprintf("azurerm_postgresql_server[%s].geo_redundant_backup_enabled", [var0]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' should be true", [var0]),
		"keyActualValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' is false", [var0]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_postgresql_server" ,var0, "geo_redundant_backup_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

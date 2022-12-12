package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_server[var0]
	not common_lib.valid_key(resource, "ssl_enforcement_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_server",
		"resourceName": tf_lib.get_resource_name(resource, var0),
		"searchKey": sprintf("azurerm_postgresql_server[%s].ssl_enforcement_enabled", [var0]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.ssl_enforcement_enabled' should equal 'true'", [var0]),
		"keyActualValue": sprintf("'azurerm_postgresql_server.%s.ssl_enforcement_enabled' is not defined", [var0]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_postgresql_server", var0, "ssl_enforcement_enabled"], []),
		"remediation": "ssl_enforcement_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_server[var0]
	resource.ssl_enforcement_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_server",
		"resourceName": tf_lib.get_resource_name(resource, var0),
		"searchKey": sprintf("azurerm_postgresql_server[%s].ssl_enforcement_enabled", [var0]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.ssl_enforcement_enabled' should equal 'true'", [var0]),
		"keyActualValue": sprintf("'azurerm_postgresql_server.%s.ssl_enforcement_enabled' is equal 'false'", [var0]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_postgresql_server", var0, "ssl_enforcement_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

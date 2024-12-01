package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azurerm_postgresql_configuration[var0]

	is_string(resource.name)
	name := lower(resource.name)

	is_string(resource.value)
	value := upper(resource.value)

	name == "log_disconnections"
	value != "ON"

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_postgresql_configuration",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_postgresql_configuration[%s].value", [var0]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_configuration.%s.value' should be 'ON'", [var0]),
		"keyActualValue": sprintf("'azurerm_postgresql_configuration.%s.value' is 'OFF'", [var0]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_postgresql_configuration", var0, "extended_auditing_policy"], []),
		"remediation": json.marshal({
			"before": sprintf("%s", [resource.value]),
			"after": "ON",
		}),
		"remediationType": "replacement",
	}
}

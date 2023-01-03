package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_configuration[var0]

	is_string(resource.name)
	name := lower(resource.name)

	is_string(resource.value)
	value := upper(resource.value)

	name == "log_retention"
	value != "ON"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_configuration",
		"resourceName": tf_lib.get_resource_name(resource, var0),
		"searchKey": sprintf("azurerm_postgresql_configuration[%s].value", [var0]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_configuration.%s.value' should be 'ON'", [var0]),
		"keyActualValue": sprintf("'azurerm_postgresql_configuration.%s.value' is 'OFF'", [var0]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_postgresql_configuration" ,var0, "value"], []),
		"remediation": json.marshal({
			"before": sprintf("%s", [resource.value]),
			"after": "ON"
		}),
		"remediationType": "replacement",
	}
}

package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_configuration[x]

	is_string(resource.name)
	name := lower(resource.name)

	is_string(resource.value)
	value := upper(resource.value)

	name == "log_duration"
	value != "ON"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_configuration",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_postgresql_configuration[%s].value", [x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_configuration.%s.value' should be 'ON'", [x]),
		"keyActualValue": sprintf("'azurerm_postgresql_configuration.%s.value' is 'OFF'", [x]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_postgresql_configuration" ,x, "value"], []),
		"remediation": json.marshal({
			"before": sprintf("%s", [resource.value]),
			"after": "ON"
		}),
		"remediationType": "replacement",
	}
}

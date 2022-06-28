package Cx

import data.generic.terraform as tf_lib

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
		"keyExpectedValue": sprintf("'azurerm_postgresql_configuration.%s.value' is 'ON'", [x]),
		"keyActualValue": sprintf("'azurerm_postgresql_configuration.%s.value' is 'OFF'", [x]),
	}
}

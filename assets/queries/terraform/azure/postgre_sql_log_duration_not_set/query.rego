package Cx

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
		"searchKey": sprintf("azurerm_postgresql_configuration[%s].value", [x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_configuration.%s.value' is 'ON'", [x]),
		"keyActualValue": sprintf("'azurerm_postgresql_configuration.%s.value' is 'OFF'", [x]),
	}
}

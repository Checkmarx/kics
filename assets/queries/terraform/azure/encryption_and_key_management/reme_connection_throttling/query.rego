package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_postgresql_configuration[var0]
	name := lower(resource.name)
	value := upper(resource.value)

    name == "connection_throttling"
    value != "ON"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_configuration[%s].value", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_configuration.%s.value' should be 'ON'", [var0]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_configuration.%s.value' is 'OFF'", [var0])
              }
}
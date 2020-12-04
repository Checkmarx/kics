package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_postgresql_configuration[var0]
	
    is_string(resource.name)
    name := lower(resource.name)

    is_string(resource.value)
	value := upper(resource.value)

    name == "log_retention"
    value != "ON"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_configuration[%s].value", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_configuration.%s.name' should be 'ON'", [var0]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_configuration.%s.name' is 'OFF'", [var0])
              }
}
package Cx

CxPolicy [ result ] {
  config := input.document[i].resource.azurerm_postgresql_configuration[name]
  config.name == "log_retention_days"

  to_number(config.value) <= 3

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_configuration[%s].value", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_configuration[%s].value' is greater than 3", [name]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_configuration[%s].value' is %s", [name,config.value])
              }
}

CxPolicy [ result ] {
  config := input.document[i].resource.azurerm_postgresql_configuration[name]
  config.name == "log_retention_days"

  to_number(config.value) > 7
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_configuration[%s].value", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_configuration[%s].value' is less than 7", [name]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_configuration[%s].value' is %s", [name,config.value])
              }
}
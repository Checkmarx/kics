package Cx

CxPolicy [ result ] {
  gateway := input.document[i].resource.azurerm_application_gateway[name]
  object.get(gateway,"waf_configuration","undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_application_gateway[%s]", [name]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("'azurerm_application_gateway[%s]' is set", [name]),
                "keyActualValue": 	sprintf("'azurerm_application_gateway[%s]' is undefined", [name])
              }
}

CxPolicy [ result ] {
  gateway := input.document[i].resource.azurerm_application_gateway[name]
  waf := gateway.waf_configuration
  waf.enabled != true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_application_gateway[%s].waf_configuration.enabled", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("'azurerm_application_gateway[%s].waf_configuration.enabled' is true", [name]),
                "keyActualValue": 	sprintf("'azurerm_application_gateway[%s].waf_configuration.enabled' is false", [name])
              }
}
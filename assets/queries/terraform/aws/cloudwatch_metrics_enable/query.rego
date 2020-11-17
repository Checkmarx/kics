package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_api_gateway_method_settings[name].settings
  resource.metrics_enabled == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_api_gateway_method_settings[%s].settings", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "metrics_enabled is true",
                "keyActualValue": 	"metrics_enabled is false"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_api_gateway_method_settings[name].settings
  not resource.metrics_enabled
  not resource.metrics_enabled == false
    
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_api_gateway_method_settings[%s].settings", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "metrics_enabled is defined",
                "keyActualValue": 	"metrics_enabled is undefined"
              }
}
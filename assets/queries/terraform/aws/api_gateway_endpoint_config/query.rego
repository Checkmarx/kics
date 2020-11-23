package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_api_gateway_rest_api[name].endpoint_configuration
  resource.types[index] == "PRIVATE"
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_api_gateway_rest_api[%s].endpoint_configuration", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  "'aws_api_gateway_rest_api.aws_api_gateway_rest_api.types' is not private",
                "keyActualValue": 	"'aws_api_gateway_rest_api.aws_api_gateway_rest_api.types' is private"
              }
}


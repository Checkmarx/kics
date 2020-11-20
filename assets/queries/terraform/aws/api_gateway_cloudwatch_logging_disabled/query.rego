package Cx

CxPolicy [ result ] {
  api_gateway := input.document[i].resource.aws_api_gateway_stage[name]
  object.get(api_gateway,"access_log_settings","undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_api_gateway_stage[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue":  sprintf("'aws_api_gateway_stage[%s].access_log_settings is set", [name]),
                "keyActualValue": 	 sprintf("'aws_api_gateway_stage[%s].access_log_settings is undefined", [name])
              }
}
package Cx   

CxPolicy [ result ] {
  resource := input.document[i].resource
  api := resource.aws_api_gateway_stage[name]
  not haveLogs(api.stage_name)
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_api_gateway_stage[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue":  "'aws_cloudwatch_log_group' is set",
                "keyActualValue": 	"'aws_cloudwatch_log_group' is undefined"
              }
}

haveLogs(stageName) = true {
    log := input.document[i].resource.aws_cloudwatch_log_group[_]
    stageName == log.name
}


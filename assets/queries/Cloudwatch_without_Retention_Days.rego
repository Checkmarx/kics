package Cx

SupportedResources = "$.resource.aws_cloudwatch_log_group"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_cloudwatch_log_group[name]
    not resource.retention_in_days

    result := {
                "foundKye": 		resource,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["resource", "aws_cloudwatch_log_group", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"retention_in_days",
                "keyExpectedValue": 30,
                "keyActualValue": 	null,
                #{metadata}
              }
}



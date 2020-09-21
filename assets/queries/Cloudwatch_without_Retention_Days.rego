package Cx

SupportedResources = "$.resource.aws_cloudwatch_log_group"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_cloudwatch_log_group[name]
    not resource.retention_in_days

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_cloudwatch_log_group[%s].retention_in_days", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": 30,
                "keyActualValue": 	null
              })
}



package Cx

CxPolicy[result] {
	db := input.document[i].resource.aws_db_instance[name]

	not db.enabled_cloudwatch_logs_exports

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'enabled_cloudwatch_logs_exports' is defined",
		"keyActualValue": "'enabled_cloudwatch_logs_exports' is undefined",
	}
}

CxPolicy[result] {
	db := input.document[i].resource.aws_db_instance[name]

	db.enabled_cloudwatch_logs_exports == null

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s].enabled_cloudwatch_logs_exports", [name]),
		"issueType": "IncorretValue",
		"keyExpectedValue": "'enabled_cloudwatch_logs_exports' has one or more values",
		"keyActualValue": "'enabled_cloudwatch_logs_exports' is empty",
	}
}

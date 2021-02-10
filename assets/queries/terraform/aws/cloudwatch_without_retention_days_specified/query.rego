package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudwatch_log_group[name]
	not resource.retention_in_days

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudwatch_log_group[%s].retention_in_days", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'retention_in_days' equal 30",
		"keyActualValue": "'retention_in_days' is missing",
	}
}

package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudwatch_log_group[name]
	not resource.retention_in_days

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("cloudwatch_log_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'retention_in_days' is set and valid",
		"keyActualValue": "Attribute 'retention_in_days' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudwatch_log_group[name]
	value := resource.retention_in_days
	validValues := [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]
	count({x | validValues[x]; validValues[x] == value}) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("cloudwatch_log_group[%s].retention_in_days", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'retention_in_days' is set and valid",
		"keyActualValue": "Attribute 'retention_in_days' is set but invalid",
	}
}

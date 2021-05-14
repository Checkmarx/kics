package Cx

CxPolicy[result] {
	resource := input.document[i].resource[name]
	name == "aws_dynamodb_table"
	res := resource[m]
	res.point_in_time_recovery.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_dynamodb_table[{{%s}}].point_in_time_recovery.enabled", [m]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "aws_dynamodb_table.point_in_time_recovery.enabled is set to true",
		"keyActualValue": "aws_dynamodb_table.point_in_time_recovery.enabled is set to false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[name]
	name == "aws_dynamodb_table"
	res := resource[m]
	object.get(res, "point_in_time_recovery", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_dynamodb_table[{{%s}}]", [m]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_dynamodb_table.point_in_time_recovery.enabled is enabled",
		"keyActualValue": "aws_dynamodb_table.point_in_time_recovery is missing",
	}
}

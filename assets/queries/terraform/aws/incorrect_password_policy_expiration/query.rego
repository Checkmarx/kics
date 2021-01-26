package Cx

CxPolicy[result] {
	expr := input.document[i].resource.aws_iam_account_password_policy[name]
	not expr.max_password_age

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_account_password_policy[%s].max_password_age", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'max_password_age' exists",
		"keyActualValue": "'max_password_age' is missing",
	}
}

CxPolicy[result] {
	expr := input.document[i].resource.aws_iam_account_password_policy[name]
	expr.max_password_age > 90

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_account_password_policy[%s].max_password_age", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'max_password_age' is lower 90",
		"keyActualValue": "'max_password_age' is higher 90",
	}
}

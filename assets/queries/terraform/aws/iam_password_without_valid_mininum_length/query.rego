package Cx

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
	not password_policy.minimum_password_length

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_account_password_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'minimum_password_length' is set and no less than 8",
		"keyActualValue": "'minimum_password_length' is undefined",
	}
}

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
	min_length := password_policy.minimum_password_length

	to_number(min_length) < 8

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_account_password_policy[%s].minimum_password_length", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'minimum_password_length' is set and no less than 8",
		"keyActualValue": "'minimum_password_length' is less than 8",
	}
}

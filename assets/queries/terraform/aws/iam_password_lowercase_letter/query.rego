package Cx

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
	object.get(password_policy, "require_lowercase_characters", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_account_password_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'require_lowercase_characters' should be set with true value",
		"keyActualValue": "'require_lowercase_characters' is undefined",
	}
}

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
	password_policy.require_lowercase_characters == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_account_password_policy[%s].require_lowercase_characters", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'require_lowercase_characters' should be true",
		"keyActualValue": "'require_lowercase_characters' is false",
	}
}

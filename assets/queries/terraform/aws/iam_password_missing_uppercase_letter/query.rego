package Cx

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
	object.get(password_policy, "require_uppercase_characters", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_account_password_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'require_uppercase_characters' should be set with true value",
		"keyActualValue": "'require_uppercase_characters' is undefined",
	}
}

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
	password_policy.require_uppercase_characters == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_account_password_policy[%s].require_uppercase_characters", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'require_uppercase_characters' should be true",
		"keyActualValue": "'require_uppercase_characters' is false",
	}
}

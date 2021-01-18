package Cx

CxPolicy[result] {
	pol := input.document[i].resource.aws_iam_account_password_policy[name]
	object.get(pol, "password_reuse_prevention", "not found") == "not found"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_account_password_policy[%s].password_reuse_prevention", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'password_reuse_prevention' exists",
		"keyActualValue": "'password_reuse_prevention' is missing",
	}
}

CxPolicy[result] {
	pol := input.document[i].resource.aws_iam_account_password_policy[name]
	pol.password_reuse_prevention = false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_account_password_policy[%s].password_reuse_prevention", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'password_reuse_prevention' is equal 'true'",
		"keyActualValue": "'password_reuse_prevention' is equal 'false'",
	}
}

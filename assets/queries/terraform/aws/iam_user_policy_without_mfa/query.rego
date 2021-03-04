package Cx

CxPolicy[result] {
	resource := input.document[i].resource
	policy := json.unmarshal(resource.aws_iam_user_policy[name].policy)
	statement := policy.Statement[_]
	statement.Action = "sts:AssumeRole"
	statement.Effect = "Allow"
	checkRoot(statement)
	not checkMFA(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource[aws_iam_user_policy].%s.policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Principal.AWS' contains ':mfa/' or 'policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent' is true",
		"keyActualValue": "'policy.Statement.Principal.AWS' doesn't contain ':mfa/' or 'policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent' is false",
	}
}

checkMFA(statement) {
	mfa := statement.Condition.BoolIfExists["aws:MultiFactorAuthPresent"]
	mfa == "true"
}

checkMFA(statement) {
	user := statement.Principal.AWS
	contains(user, ":mfa/")
}

checkRoot(statement) {
	user := statement.Principal.AWS
	contains(user, "root")
}

checkRoot(statement) {
	input.document[i].resource.aws_iam_user_policy[name].user == "root"
}

checkRoot(statement) {
	input.document[i].resource.aws_iam_user[name].name == "root"
}

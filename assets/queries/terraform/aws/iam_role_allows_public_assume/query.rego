package Cx

CxPolicy[result] {
	policy := input.document[i].resource.aws_iam_role[name].assume_role_policy
	re_match("Service", policy)
	out := json.unmarshal(policy)
	not out.Statement[ix].Effect
	aws := out.Statement[ix].Principal.AWS
	contains(aws, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'assume_role_policy.Statement.Principal.AWS' doesn't contain '*'",
		"keyActualValue": "'assume_role_policy.Statement.Principal.AWS' contains '*'",
	}
}

CxPolicy[result] {
	policy := input.document[i].resource.aws_iam_role[name].assume_role_policy
	re_match("Service", policy)
	out := json.unmarshal(policy)
	out.Statement[ix].Effect != "Deny"
	aws := out.Statement[ix].Principal.AWS
	contains(aws, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'assume_role_policy.Statement.Principal.AWS' doesn't contain '*'",
		"keyActualValue": "'assume_role_policy.Statement.Principal.AWS' contains '*'",
	}
}

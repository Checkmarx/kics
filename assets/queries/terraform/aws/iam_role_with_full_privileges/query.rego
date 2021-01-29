package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]
	out := json.unmarshal(resource.assume_role_policy)
	statements := out.Statement[_]
	statements.Action[_] == "*"
	statements.Effect == "Allow"
	statements.Resource == "*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy.Statement.Action", [name]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "'assume_role_policy.Statement.Action' doesn't contain '*'",
		"keyActualValue": "'assume_role_policy.Statement.Action' contains '*'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]
	out := json.unmarshal(resource.assume_role_policy)
	statements := out.Statement[_]
	statements.Action == "*"
	statements.Effect == "Allow"
	statements.Resource == "*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy.Statement.Action", [name]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "'assume_role_policy.Statement.Action' isn't equal to '*'",
		"keyActualValue": "'assume_role_policy.Statement.Action' is equal '*'",
	}
}

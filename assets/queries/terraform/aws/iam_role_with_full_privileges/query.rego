package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]

	policy := commonLib.json_unmarshal(resource.assume_role_policy)
	statement := policy.Statement[_]

	statement.Effect == "Allow"
	statement.Resource == "*"
	commonLib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "assume_role_policy.Statement.Action is not equal to, nor does it contain '*'",
		"keyActualValue": "assume_role_policy.Statement.Action is equal to or contains '*'",
	}
}

package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	policy := input.document[i].resource.aws_iam_role_policy[name].policy

	out := commonLib.json_unmarshal(policy)
	check_passrole(out.Statement[idx])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role_policy[%s].policy.Statement.Action.{{iam:passrole}}", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_iam_role_policy.policy.Statement.Action' iam:passrole doesn't have Resource '*'",
		"keyActualValue": "'aws_iam_role_policy.policy.Statement.Action' iam:passrole has Resource '*'",
	}
}

check_passrole(statement) {
	is_string(statement.Action)
	statement.Action == "iam:passrole"
	statement.Resource == "*"
} else {
	is_array(statement.Action)
	statement.Action[n] == "iam:passrole"
	statement.Resource == "*"
}

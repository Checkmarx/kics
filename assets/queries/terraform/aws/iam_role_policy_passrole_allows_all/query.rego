package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	policy := input.document[i].resource.aws_iam_role_policy[name].policy

	out := common_lib.json_unmarshal(policy)
	st := common_lib.get_statement(out)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	check_passrole(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_iam_role_policy.policy.Statement.Action' iam:passrole doesn't have Resource '*'",
		"keyActualValue": "'aws_iam_role_policy.policy.Statement.Action' iam:passrole has Resource '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_role_policy", name, "policy"], []),
	}
}

check_passrole(statement) {
	common_lib.equalsOrInArray(statement.Action, "iam:passrole")
	common_lib.equalsOrInArray(statement.Resource, "*")
}

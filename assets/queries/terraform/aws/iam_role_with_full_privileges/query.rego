package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]

	policy := common_lib.json_unmarshal(resource.assume_role_policy)
		st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Resource, "*")
	common_lib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "assume_role_policy.Statement.Action is not equal to, nor does it contain '*'",
		"keyActualValue": "assume_role_policy.Statement.Action is equal to or contains '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_role", name, "assume_role_policy"], []),
	}
}

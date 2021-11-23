package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i].resource
	[path, value] := walk(doc)

	policy := common_lib.json_unmarshal(value.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)

	not common_lib.valid_key(statement, "Principal")

	not is_iam_identity_based_policy(path[0])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy", [path[0], path[1]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'Principal' is set",
		"keyActualValue": "'Principal' is undefined",
		"searchLine": common_lib.build_search_line(["resource", path[0], path[1], "policy"], []),
	}
}

is_iam_identity_based_policy(resource) {
	iam_identity_based_policy := {"aws_iam_group_policy", "aws_iam_policy", "aws_iam_role_policy", "aws_iam_user_policy"}
	resource == iam_identity_based_policy[_]
}

package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i].resource
	[path, value] := walk(doc)
	not is_iam_identity_based_policy(path[0])

	policy := common_lib.json_unmarshal(value.policy)
	statement := common_lib.get_statement(policy)[_]

	common_lib.is_allow_effect(statement)
	not has_principal(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": path[0],
		"resourceName": path[1],
		"searchKey": sprintf("%s[%s].policy", [path[0], path[1]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'Principal' should be defined",
		"keyActualValue": "'Principal' is undefined",
		"searchLine": common_lib.build_search_line(["resource", path[0], path[1], "policy"], []),
	}
}

is_iam_identity_based_policy(resource) {
	iam_identity_based_policy := {"aws_iam_group_policy", "aws_iam_policy", "aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_role"}
	resource == iam_identity_based_policy[_]
}

has_principal(statement) {
	common_lib.valid_key(statement, "Principals") # iam_policy_document
} else {
	common_lib.valid_key(statement, "Principal")
}

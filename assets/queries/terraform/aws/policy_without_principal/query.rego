package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	doc := input.document[i].resource
	[path, value] := walk(doc)

	policy := commonLib.json_unmarshal(value.policy)

	object.get(policy.Statement[idx], "Principal", "undefined") == "undefined"

	not is_iam_identity_based_policy(path[0])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy.Statement", [path[0], path[1]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'Principal' is set",
		"keyActualValue": "'Principal' is undefined",
	}
}

is_iam_identity_based_policy(resource) {
	iam_identity_based_policy := {"aws_iam_group_policy", "aws_iam_policy", "aws_iam_role_policy", "aws_iam_user_policy"}
	resource == iam_identity_based_policy[_]
}

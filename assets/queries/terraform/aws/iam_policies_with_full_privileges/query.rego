package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resourceType := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy_attachment", "aws_iam_policy"}
	resource := input.document[i].resource[resourceType[idx]][name]

	policy := commonLib.json_unmarshal(resource.policy)
	policy.Statement[ix].Resource == "*"
	policy.Statement[ix].Effect == "Allow"
	policy.Statement[ix].Action == ["*"]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy", [resourceType[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' doesn't contain '*'",
		"keyActualValue": "'policy.Statement.Action' contains '*'",
	}
}

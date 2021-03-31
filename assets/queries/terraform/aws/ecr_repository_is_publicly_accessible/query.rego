package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository_policy[name]
	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]
	statement.Effect == "Allow"
	statement.Principal == "*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Statement.Principal' doesn't contain '*'",
		"keyActualValue": "'Statement.Principal' contains '*'",
	}
}

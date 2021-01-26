package Cx

CxPolicy[result] {
	pol := input.document[i].resource.aws_ecr_repository_policy[name].policy
	re_match("\"Principal\"\\s*:\\s*\"*\"", pol)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Principal' is not equal '*'",
		"keyActualValue": "'policy.Principal' is equal '*'",
	}
}

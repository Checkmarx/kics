package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository_policy[name]
	jsonPolicy := json.unmarshal(resource.policy)
	policyStat := jsonPolicy.Statement[_]
	policyStat.Effect == "Allow"
	policyStat.Principal == "*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s", [policyStat.Principal]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Statement.Principal' doesn't contain '*'",
		"keyActualValue": "'Statement.Principal' contains '*'",
	}
}

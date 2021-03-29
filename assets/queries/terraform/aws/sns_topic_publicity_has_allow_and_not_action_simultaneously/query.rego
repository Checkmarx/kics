package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	document := input.document[i]
	resources := {"aws_sns_topic", "aws_sns_topic_policy"}
	policy := document.resource[resources[r]][name].policy

	validate_json(policy)

	pol := commonLib.json_unmarshal(policy)
	statement := pol.Statement[s]

	statement.Effect == "Allow"
	statement.NotAction

	result := {
		"documentId": document.id,
		"searchKey": sprintf("%s[%s].policy.Sid", [resources[r], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Sid doesn't have 'Effect: Allow' and 'NotAction' simultaneously", [resources[r], name]),
		"keyActualValue": sprintf("%s[%s].policy.Sid has 'Effect: Allow' and 'NotAction' simultaneously", [resources[r], name]),
	}
}

validate_json(string) {
	not startswith(string, "$")
}

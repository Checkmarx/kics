package Cx

import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudwatch_log_destination_policy[name]

	policyName := split(resource.access_policy, ".")[2]

	policy := input.document[j].data.aws_iam_policy_document[policyName]

	terraLib.has_wildcard(policy.statement, "logs:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("ws_cloudwatch_log_destination_policy[%s].access_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ws_cloudwatch_log_destination_policy[%s].access_policy does not have wildcard in 'principals' and 'actions'", [name]),
		"keyActualValue": sprintf("ws_cloudwatch_log_destination_policy[%s].access_policy has wildcard in 'principals' or 'actions'", [name]),
	}
}

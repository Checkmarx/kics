package Cx

import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_glue_resource_policy[name]

	policyName := split(resource.policy, ".")[2]

	policy := input.document[j].data.aws_iam_policy_document[policyName]

	terraLib.has_wildcard(policy.statement, "glue:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_glue_resource_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_glue_resource_policy[%s].policy does not have wildcard in 'principals' and 'actions'", [name]),
		"keyActualValue": sprintf("aws_glue_resource_policy[%s].policy has wildcard in 'principals' or 'actions'", [name]),
	}
}

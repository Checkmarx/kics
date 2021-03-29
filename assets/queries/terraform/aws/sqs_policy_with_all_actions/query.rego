package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue_policy[name]

	policy := commonLib.json_unmarshal(resource.policy)
	commonLib.equalsOrInArray(policy.Statement[idx].Action, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue_policy[%s].policy.Action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' is not equal '*'",
		"keyActualValue": "'policy.Statement.Action' is equal '*'",
	}
}

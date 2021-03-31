package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue_policy[name]

	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]

	statement.Effect == "Allow"
	commonLib.containsOrInArrayContains(statement.Action, "*")
	terraLib.anyPrincipal(statement)

	queue_name := trim_prefix(trim_suffix(resource.queue_url, ".id}"), "${aws_sqs_queue.")
	queue_resource := input.document[j].resource.aws_sqs_queue[queue_name]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Principal.AWS' is not equal '*'",
		"keyActualValue": "'policy.Statement.Principal.AWS' is equal '*'",
	}
}

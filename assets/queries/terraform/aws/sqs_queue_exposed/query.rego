package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue[name]
	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]
	terraLib.anyPrincipal(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_sqs_queue[%s].policy.Principal doesn't get the queue publicly accessible", [name]),
		"keyActualValue": sprintf("resource.aws_sqs_queue[%s].policy.Principal does get the queue publicly accessible", [name]),
	}
}

package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	sqsPolicy := task["community.aws.sqs_queue"]

	contains(sqsPolicy.policy.Statement[_].Action, "*")

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Statement", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Statement should not contain Action equal to '*'", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Statement contains Action equal to '*'", [task.name]),
	}
}

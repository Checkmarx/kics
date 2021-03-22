package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.sqs_queue", "sqs_queue"}
	sqsPolicy := task[modules[m]]
	ansLib.checkState(sqsPolicy)

	contains(sqsPolicy.policy.Statement[_].Action, "*")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy.Statement", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sqs_queue.policy.Statement should not contain Action equal to '*'",
		"keyActualValue": "sqs_queue.policy.Statement contains Action equal to '*'",
	}
}

package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.sqs_queue", "sqs_queue"}
	sqs_queue := task[modules[m]]
	ansLib.checkState(sqs_queue)

	isAccessible(sqs_queue)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy.Principal", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sqs_queue.policy.Principal doesn't get the queue publicly accessible",
		"keyActualValue": "sqs_queue.policy.Principal does get the queue publicly accessible",
	}
}

isAccessible(task) {
	task.policy.Statement.Principal == "*"
}

isAccessible(task) {
	task.policy.Statement[s].Principal == "*"
}

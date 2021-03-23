package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.sqs_queue", "sqs_queue"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	sqsPolicy := task[modules[m]]
	ansLib.checkState(sqsPolicy)

	contains(sqsPolicy.policy.Statement[_].Principal, "*")
	contains(sqsPolicy.policy.Statement[_].Effect, "Allow")
	contains(sqsPolicy.policy.Statement[_].Action, "*")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy.Principal", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sqs_queue.policy.Principal should not be equal to '*'",
		"keyActualValue": "sqs_queue.policy.Principal is equal to '*'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	sqsPolicy := task[modules[m]]
	ansLib.checkState(sqsPolicy)

	contains(sqsPolicy.policy.Statement[_].Effect, "Allow")
	contains(sqsPolicy.policy.Statement[_].Action, "*")
	checkPrincipal(sqsPolicy.policy.Statement[_].Principal[j])

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy.Principal.AWS", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sqs_queue.policy.Principal.AWS should not be equal to '*'",
		"keyActualValue": "sqs_queue.policy.Principal.AWS is equal to '*'",
	}
}

checkPrincipal(principal) {
	contains(principal.AWS, "*")
} else {
	contains(principal.AWS[k], "*")
}

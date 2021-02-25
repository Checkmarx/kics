package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	sqsPolicy := task["community.aws.sqs_queue"]

	contains(sqsPolicy.policy.Statement[_].Principal, "*")
	contains(sqsPolicy.policy.Statement[_].Effect, "Allow")
	contains(sqsPolicy.policy.Statement[_].Action, "*")

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal should not be equal to '*'", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal is equal to '*'", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	sqsPolicy := task["community.aws.sqs_queue"]

	contains(sqsPolicy.policy.Statement[_].Effect, "Allow")
	contains(sqsPolicy.policy.Statement[_].Action, "*")
	checkPrincipal(sqsPolicy.policy.Statement[_].Principal[j])

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal.AWS", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal.AWS should not be equal to '*'", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal.AWS is equal to '*'", [task.name]),
	}
}

checkPrincipal(principal) {
	contains(principal.AWS, "*")
} else {
	contains(principal.AWS[k], "*")
}

package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib
import future.keywords.in

modules := {"community.aws.sqs_queue", "sqs_queue"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	sqsPolicy := task[modules[m]]
	ans_lib.checkState(sqsPolicy)

	st := common_lib.get_statement(common_lib.get_policy(sqsPolicy.policy))
	some statement in st

	common_lib.is_allow_effect(statement)
	all_principals(statement)
	common_lib.containsOrInArrayContains(statement.Action, "*")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sqs_queue.policy.Principal should not equal to '*'",
		"keyActualValue": "sqs_queue.policy.Principal is equal to '*'",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}

all_principals(statement) {
	common_lib.containsOrInArrayContains(statement.Principal.AWS, "*")
} else {
	statement.Principal == "*"
}

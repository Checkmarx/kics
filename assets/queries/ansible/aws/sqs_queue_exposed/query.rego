package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"community.aws.sqs_queue", "sqs_queue"}
	sqs_queue := task[modules[m]]
	ans_lib.checkState(sqs_queue)

	st := common_lib.get_statement(common_lib.get_policy(sqs_queue.policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)

	statement.Principal == "*"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sqs_queue.policy.Principal shouldn't get the queue publicly accessible",
		"keyActualValue": "sqs_queue.policy.Principal does get the queue publicly accessible",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}

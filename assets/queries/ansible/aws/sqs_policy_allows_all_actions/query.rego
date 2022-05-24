package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"community.aws.sqs_queue", "sqs_queue"}
	sqsPolicy := task[modules[m]]
	ans_lib.checkState(sqsPolicy)

	st := common_lib.get_statement(common_lib.get_policy(sqsPolicy.policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sqs_queue.policy.Statement should not contain Action equal to '*'",
		"keyActualValue": "sqs_queue.policy.Statement contains Action equal to '*'",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}

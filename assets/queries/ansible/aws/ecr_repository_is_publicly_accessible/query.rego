package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"community.aws.ecs_ecr", "ecs_ecr"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	cloudwatchlogs := task[modules[m]]
	ans_lib.checkState(cloudwatchlogs)

	st := common_lib.get_statement(common_lib.get_policy(cloudwatchlogs.policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)

	contains(statement.Principal, "*")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ecs_ecr.policy.Principal should not equal to '*'",
		"keyActualValue": "ecs_ecr.policy.Principal is equal to '*'",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}

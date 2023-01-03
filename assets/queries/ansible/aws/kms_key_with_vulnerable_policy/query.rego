package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib


CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"community.aws.aws_kms", "aws_kms"}
	aws_kms := task[modules[m]]
	ans_lib.checkState(aws_kms)

	st := common_lib.get_statement(common_lib.get_policy(aws_kms.policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	not common_lib.valid_key(statement, "Condition")
	common_lib.has_wildcard(statement, "kms:*")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_kms.policy should not have wildcard in 'Action' and 'Principal'",
		"keyActualValue": "aws_kms.policy has wildcard in 'Action' or 'Principal'",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"community.aws.aws_kms", "aws_kms"}
	aws_kms := task[modules[m]]
	ans_lib.checkState(aws_kms)

	not common_lib.valid_key(aws_kms, "policy")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'policy' should be undefined or null",
		"keyActualValue": "'policy' is defined and not null",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m]], []),
	}
}

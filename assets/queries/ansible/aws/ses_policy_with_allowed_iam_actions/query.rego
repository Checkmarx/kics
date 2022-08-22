package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"community.aws.aws_ses_identity_policy", "aws.aws_ses_identity_policy"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	sesPolicy := task[modules[m]]
	ans_lib.checkState(sesPolicy)

	st := common_lib.get_statement(common_lib.get_policy(sesPolicy.policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.containsOrInArrayContains(statement.Action, "*")
	common_lib.any_principal(statement)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy' should not allow IAM actions to all principals",
		"keyActualValue": "'policy' allows IAM actions to all principals",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}

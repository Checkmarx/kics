package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"amazon.aws.s3_bucket", "s3_bucket"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	s3_bucket := task[modules[m]]
	ans_lib.checkState(s3_bucket)

	st := common_lib.get_statement(common_lib.get_policy(s3_bucket.policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)

	common_lib.containsOrInArrayContains(statement.Action, "*")
	common_lib.containsOrInArrayContains(statement.Principal, "*")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement' should not allow all actions to all principal",
		"keyActualValue": "'policy.Statement' allows all actions to all principal",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}

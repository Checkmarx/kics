package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"amazon.aws.s3_bucket", "s3_bucket"}
	bucket := task[modules[m]]
	ans_lib.checkState(bucket)

	st := common_lib.get_statement(common_lib.get_policy(bucket.policy))
	some statement in st

	common_lib.is_allow_effect(statement)

	common_lib.containsOrInArrayContains(statement.Action, "get")
	statement.Principal == "*"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("s3_bucket[%s] should not allow Get Action From All Principals", [bucket.name]),
		"keyActualValue": sprintf("s3_bucket[%s] allows Get Action From All Principals", [bucket.name]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}

package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"amazon.aws.s3_bucket", "s3_bucket"}
	s3_bucket := task[modules[m]]
	ans_lib.checkState(s3_bucket)

	st := common_lib.get_statement(common_lib.get_policy(s3_bucket.policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	statement.Principal == "*"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "s3_bucket.policy.Statement shouldn't make the bucket accessible to all AWS Accounts",
		"keyActualValue": "s3_bucket.policy.Statement does make the bucket accessible to all AWS Accounts",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}

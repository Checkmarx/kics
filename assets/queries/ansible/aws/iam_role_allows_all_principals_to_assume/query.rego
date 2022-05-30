package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"community.aws.iam_managed_policy", "iam_managed_policy"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	awsApiGateway := task[modules[m]]
	ans_lib.checkState(awsApiGateway)

	policy := common_lib.get_policy(common_lib.get_policy(awsApiGateway.policy))
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	aws := statement.Principal.AWS

	common_lib.allowsAllPrincipalsToAssume(aws, statement)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "iam_managed_policy.policy.Statement.Principal.AWS should not contain ':root",
		"keyActualValue": "iam_managed_policy.policy.Statement.Principal.AWS contains ':root'",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}

package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"community.aws.iam_role", "iam_role"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	iamRole := task[modules[m]]
	ans_lib.checkState(iamRole)

	policy := iamRole.assume_role_policy_document
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)

	common_lib.is_cross_account(statement)
	common_lib.is_assume_role(statement)

	not common_lib.has_external_id(statement)
	not common_lib.has_mfa(statement)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.assume_role_policy_document", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "assume_role_policy_document should not contain ':root",
		"keyActualValue": "assume_role_policy_document contains ':root'",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "assume_role_policy_document"], []),
	}
}

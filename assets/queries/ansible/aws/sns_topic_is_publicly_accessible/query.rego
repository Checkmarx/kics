package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.sns_topic", "sns_topic"}
	snsTopicCommunity := task[modules[m]]
	ansLib.checkState(snsTopicCommunity)
    st := common_lib.get_statement(common_lib.get_policy(snsTopicCommunity.policy))
	statement := st[_]

	statement.Effect == "Allow"
	common_lib.any_principal(statement)

	not common_lib.is_access_limited_to_an_account_id(statement)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sns_topic.policy.Statement shouldn't contain '*' for an AWS Principal",
		"keyActualValue": "sns_topic.policy.Statement contains '*' in an AWS Principal",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "policy"], []),
	}
}
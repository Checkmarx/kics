package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)

	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' is not equal '*'",
		"keyActualValue": "'policy.Statement.Action' is equal '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue_policy", name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sqs_queue_policy", "policy")

	policy := common_lib.json_unmarshal(module[keyToCheck])

	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' is not equal '*'",
		"keyActualValue": "'policy.Statement.Action' is equal '*'",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
	}
}

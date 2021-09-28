package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	common_lib.equalsOrInArray(policy.Statement[idx].Action, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue_policy[%s].policy.Action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' is not equal '*'",
		"keyActualValue": "'policy.Statement.Action' is equal '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue_policy", name, "policy", "Statement", idx, "Action"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sqs_queue_policy", "policy")

	policy := common_lib.json_unmarshal(module[keyToCheck])
	common_lib.equalsOrInArray(policy.Statement[idx].Action, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].%s.Action", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' is not equal '*'",
		"keyActualValue": "'policy.Statement.Action' is equal '*'",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck, "Statement", idx, "Action"], []),
	}
}

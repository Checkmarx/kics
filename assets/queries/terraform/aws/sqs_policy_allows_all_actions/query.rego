package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue_policy[name]

	tf_lib.allows_action_from_all_principals(resource.policy, "*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_sqs_queue_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sqs_queue_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' should not equal '*'",
		"keyActualValue": "'policy.Statement.Action' is equal '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue_policy", name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sqs_queue_policy", "policy")

	tf_lib.allows_action_from_all_principals(module[keyToCheck], "*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' should not equal '*'",
		"keyActualValue": "'policy.Statement.Action' is equal '*'",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
	}
}

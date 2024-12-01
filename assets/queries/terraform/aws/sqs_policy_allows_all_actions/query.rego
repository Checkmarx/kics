package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_sqs_queue_policy[name]

	tf_lib.allows_action_from_all_principals(resource.policy, "*")

	result := {
		"documentId": doc.id,
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
	some doc in input.document
	module := doc.module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sqs_queue_policy", "policy")

	tf_lib.allows_action_from_all_principals(module[keyToCheck], "*")

	result := {
		"documentId": doc.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' should not equal '*'",
		"keyActualValue": "'policy.Statement.Action' is equal '*'",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
	}
}

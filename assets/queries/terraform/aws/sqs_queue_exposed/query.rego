package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue[name]

	exposed(resource.policy)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_sqs_queue",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sqs_queue[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_sqs_queue[%s].policy.Principal shouldn't get the queue publicly accessible", [name]),
		"keyActualValue": sprintf("resource.aws_sqs_queue[%s].policy.Principal does get the queue publicly accessible", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue", name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sqs_queue", "policy")

	exposed(module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Principal' shouldn't get the queue publicly accessible",
		"keyActualValue": "'policy.Principal' does get the queue publicly accessible",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

exposed(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	tf_lib.anyPrincipal(statement)
}

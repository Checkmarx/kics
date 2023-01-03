package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	resources := {"aws_sns_topic", "aws_sns_topic_policy"}
	resource := document.resource[resources[r]][name]
	policy := resource.policy

	validate_json(policy)

	pol := common_lib.json_unmarshal(policy)
	st := common_lib.get_statement(pol)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	statement.NotAction

	result := {
		"documentId": document.id,
		"resourceType": resources[r],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].policy", [resources[r], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy shouldn't have 'Effect: Allow' and 'NotAction' simultaneously", [resources[r], name]),
		"keyActualValue": sprintf("%s[%s].policy has 'Effect: Allow' and 'NotAction' simultaneously", [resources[r], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[r], name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sns_topic_policy", "policy")

	policy := module[keyToCheck]

	validate_json(policy)

	pol := common_lib.json_unmarshal(policy)
	st := common_lib.get_statement(pol)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	statement.NotAction

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].policy shouldn't have 'Effect: Allow' and 'NotAction' simultaneously", [name]),
		"keyActualValue": sprintf("module[%s].policy has 'Effect: Allow' and 'NotAction' simultaneously", [name]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
	}
}

validate_json(string) {
	not startswith(string, "$")
}

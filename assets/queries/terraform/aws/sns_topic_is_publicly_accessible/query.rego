package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sns_topic[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	tf_lib.anyPrincipal(statement)

	not is_access_limited_to_an_account_id(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_sns_topic",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sns_topic[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Statement.Principal.AWS' shouldn't contain '*'",
		"keyActualValue": "'Statement.Principal.AWS' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_sns_topic", name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sns_topic", "")
}

get_module_res(module) = res {

	res := {
		
	}
}

is_access_limited_to_an_account_id(statement) {
	common_lib.valid_key(statement, "Condition")
	condition_keys := ["aws:SourceOwner", "aws:SourceAccount", "aws:ResourceAccount", "aws:PrincipalAccount", "aws:VpceAccount"]
	condition_operator := statement.Condition[op][key]
	lower(key) == lower(condition_keys[_])
}
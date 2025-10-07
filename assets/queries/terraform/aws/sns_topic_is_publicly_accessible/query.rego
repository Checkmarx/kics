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
	get_module_res(module, keyToCheck, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchName": res["sk"],
		"issueType": "IncorrectValue",
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
	}
}

get_module_res(module, keyToCheck, name) {
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sns_topic", "policy")
	common_lib.valid_key(module, keyToCheck)
	policy := common_lib.json_unmarshal(module[keyToCheck])
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.anyPrincipal(statement)
	
	common_lib.is_allow_effect(statement)
	tf_lib.anyPrincipal(statement)

	not is_access_limited_to_an_account_id(statement)

	res := {
		"sk": sprintf("topic_policy", []),
		"kev": sprintf("'Statement.Policy.AWS' shouldn't contain '*'", []),
		"kav": sprintf("'Statement.Policy.AWS' contains '*'", []),
		"sl": common_lib.build_search_line(["module", name, "topic_policy"], []),
	}
} else = res {
	common_lib.valid_key(module, "topic_policy_statements")
	statement := module.topic_policy_statements[idx]
	common_lib.is_allow_effect(statement)
	principal := statement.principals[idx_principals]
	principal.type == "AWS"
	contains(principal.identifiers[idx_identifiers], "*")

	not is_access_limited_to_an_account_id(statement)

	res := {
		"sk": sprintf("topic_policy_statements[%d].principals[%d].identifiers[%d]", [idx, idx_principals, idx_identifiers]),
		"kev": "AWS Principal shouldn't contain '*' on the identifiers",
		"kav": "AWS Princiapl contains '*' on the identifiers",
		"sl": common_lib.build_search_line(["module", name, "topic_policy_statements", idx, "principals", idx_principals, "identifiers", idx_identifiers], []),
	}
}

is_access_limited_to_an_account_id(statement) {
	common_lib.valid_key(statement, "Condition")
	condition_keys := ["aws:SourceOwner", "aws:SourceAccount", "aws:ResourceAccount", "aws:PrincipalAccount", "aws:VpceAccount"]
	condition_operator := statement.Condition[op][key]
	lower(key) == lower(condition_keys[_])
} else {
	common_lib.valid_key(statement, "condition")
	condition_keys := ["aws:SourceOwner", "aws:SourceAccount", "aws:ResourceAccount", "aws:PrincipalAccount", "aws:VpceAccount"]
	condition_operator := statement.condition[op][key]
	lower(key) == lower(condition_keys[_])
}
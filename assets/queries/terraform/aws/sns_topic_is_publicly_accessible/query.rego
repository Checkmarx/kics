package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sns_topic[name]

	policy := common_lib.get_policy(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[st_id]

	common_lib.is_allow_effect(statement)
	tf_lib.anyPrincipal(statement)

	not common_lib.is_access_limited_to_an_account_id(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_sns_topic",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sns_topic[%s].policy", [name]),
		"searchValue": sprintf("%d",[st_id]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Statement[%d].Principal.AWS' shouldn't contain '*'",[st_id]),
		"keyActualValue": sprintf("'Statement[%d].Principal.AWS' contains '*'",[st_id]),
		"searchLine": common_lib.build_search_line(["resource", "aws_sns_topic", name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sns_topic", "policy")
	results_array := get_module_res(module, keyToCheck, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": results_array[index].sk,
		"searchValue": results_array[index].sv,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results_array[index].kev,
		"keyActualValue": results_array[index].kav,
		"searchLine": results_array[index].sl,
	}
}

get_module_res(module, keyToCheck, name) = res {
	common_lib.valid_key(module, keyToCheck)
	policy := common_lib.get_policy(module[keyToCheck])
	st := common_lib.get_statement(policy)

	res := [{ "sk": "topic_policy",
			  "sv": sprintf("%d",[st_id]),
			  "kev": sprintf("'Statement[%d].Principal.AWS' shouldn't contain '*'", [st_id]),
			  "kav": sprintf("'Statement[%d].Principal.AWS' contains '*'", [st_id]),
			  "sl": common_lib.build_search_line(["module", name, "topic_policy"], [])} |
		statement := st[st_id]
		common_lib.is_allow_effect(statement)
		tf_lib.anyPrincipal(statement)
		not common_lib.is_access_limited_to_an_account_id(statement)]

} else = res {
	common_lib.valid_key(module, "topic_policy_statements")

	res := [{"sk": sprintf("module[%s].topic_policy_statements[%d].principals", [name, idx]),
			 "sv": "",
			 "kev": sprintf("'topic_policy_statements[%d].principals[%d].identifiers' shouldn't contain '*' for an AWS Principal", [idx, idx_principals]),
			 "kav": sprintf("'topic_policy_statements[%d].principals[%d].identifiers' contains '*' for an AWS Principal", [idx, idx_principals]),
			 "sl": common_lib.build_search_line(["module", name, "topic_policy_statements", idx, "principals"], [])}|
		statement := module.topic_policy_statements[idx]
		common_lib.is_allow_effect(statement)
		principal := statement.principals[idx_principals]
		principal.type == "AWS"
		contains(principal.identifiers[idx_identifiers], "*")

	not common_lib.is_access_limited_to_an_account_id(statement)]
}

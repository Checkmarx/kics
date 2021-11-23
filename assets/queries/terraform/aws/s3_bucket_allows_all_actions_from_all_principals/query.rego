package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	resourceValue := pl[r]
	resource := input.document[i].resource[resourceValue][name]

	all_actions_from_all_principals(resource.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy.Action", [resourceValue, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' doesn't contain '*' when 'policy.Statement.Principal' contains '*'",
		"keyActualValue": "'policy.Statement.Action' contains '*' when 'policy.Statement.Principal' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", resourceValue, name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	resourceValue := pl[r]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, resourceValue, "policy")

	all_actions_from_all_principals(module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' doesn't contain '*' when 'policy.Statement.Principal' contains '*'",
		"keyActualValue": "'policy.Statement.Action' contains '*' when 'policy.Statement.Principal' contains '*'",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}


all_actions_from_all_principals(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	terra_lib.anyPrincipal(statement)
	common_lib.containsOrInArrayContains(statement.Action, "*")
}

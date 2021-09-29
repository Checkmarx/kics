package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	resourceType := pl[r]
	resource := input.document[i].resource[resourceType][name]

	list_action_from_all_principals(resource.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' is not a 'List' action when 'policy.Statement.Principal' contains '*'",
		"keyActualValue": "'policy.Statement.Action' is a 'List' action when 'policy.Statement.Principal' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	resourceValue := pl[r]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, resourceValue, "policy")

	list_action_from_all_principals(module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' is not a 'List' action when 'policy.Statement.Principal' contains '*'",
		"keyActualValue": "'policy.Statement.Action' is a 'List' action when 'policy.Statement.Principal' contains '*'",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

list_action_from_all_principals(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	statement := policy.Statement[_]

	statement.Effect == "Allow"
	terra_lib.anyPrincipal(statement)
	common_lib.containsOrInArrayContains(statement.Action, "list")
}

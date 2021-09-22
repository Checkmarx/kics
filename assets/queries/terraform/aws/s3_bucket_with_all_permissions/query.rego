package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]

	all_permissions(resource.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' doesn't contain '*'",
		"keyActualValue": "'policy.Statement.Action' contain '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "policy")

	all_permissions(module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' doesn't contain '*'",
		"keyActualValue": "'policy.Statement.Action' contain '*'",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

all_permissions(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	statement := policy.Statement[_]

	statement.Effect == "Allow"
	common_lib.containsOrInArrayContains(statement.Action, "*")
}

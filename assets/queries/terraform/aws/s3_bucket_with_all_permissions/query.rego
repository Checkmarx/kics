package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]

	all_permissions(resource.policy)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("aws_s3_bucket[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement' should not allow all actions to any principal",
		"keyActualValue": "'policy.Statement' allows all actions to any principal",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "policy")

	all_permissions(module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement' should not allow all actions to any principal",
		"keyActualValue": "'policy.Statement' allows all actions to any principal",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

all_permissions(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.containsOrInArrayContains(statement.Action, "*")
	common_lib.containsOrInArrayContains(statement.Principal, "*")
}

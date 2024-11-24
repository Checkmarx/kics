package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

resource_type := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	some res_type in resource_type
	some document in input.document
	resource := document.resource[res_type][name]

	all_permissions(resource.policy)

	result := {
		"documentId": document.id,
		"resourceType": res_type,
		"resourceName": tf_lib.get_specific_resource_name(resource, res_type, name),
		"searchKey": sprintf("%s[%s].policy", [res_type, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement' should not allow all actions to all principal",
		"keyActualValue": "'policy.Statement' allows all actions to all principal",
		"searchLine": common_lib.build_search_line(["resource", res_type, name, "policy"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	module := document.module[name]
	some res_type in resource_type
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, res_type, "policy")

	all_permissions(module[keyToCheck])

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement' should not allow all actions to all principal",
		"keyActualValue": "'policy.Statement' allows all actions to all principal",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

all_permissions(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	st := common_lib.get_statement(policy)
	some statement in st

	common_lib.is_allow_effect(statement)
	common_lib.containsOrInArrayContains(statement.Action, "*")
	common_lib.containsOrInArrayContains(statement.Principal, "*")
}

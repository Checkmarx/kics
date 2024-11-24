package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	resourceType := pl[r]
	some document in input.document
	resource := document.resource[resourceType][name]

	access_to_any_principal(resource.policy)

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("%s[%s].policy", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Principal should not equal to, nor contain '*'", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].policy.Principal is equal to or contains '*'", [resourceType, name]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "policy"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	module := document.module[name]
	resourceType := pl[r]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, resourceType, "policy")

	access_to_any_principal(module[keyToCheck])

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Principal' should not equal to, nor contain '*'",
		"keyActualValue": "'policy.Principal' is equal to or contains '*'",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

access_to_any_principal(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	st := common_lib.get_statement(policy)
	some statement in st

	common_lib.is_allow_effect(statement)
	tf_lib.anyPrincipal(statement)
}

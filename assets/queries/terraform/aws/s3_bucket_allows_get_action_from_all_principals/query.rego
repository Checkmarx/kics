package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	some document in input.document
	resource := document.resource[pl[r]][name]
	tf_lib.allows_action_from_all_principals(resource.policy, "get")

	result := {
		"documentId": document.id,
		"resourceType": pl[r],
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("%s[%s].policy.Action", [pl[r], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Action should not be a 'Get' action", [pl[r], name]),
		"keyActualValue": sprintf("%s[%s].policy.Action is a 'Get' action", [pl[r], name]),
		"searchLine": common_lib.build_search_line(["resource", pl[r], name, "policy", "Statement"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	module := document.module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "policy")
	tf_lib.allows_action_from_all_principals(module[keyToCheck], "get")

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s.Action", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].policy.Action should not be a 'Get' action", [name]),
		"keyActualValue": sprintf("module[%s].policy.Action is a 'Get' action", [name]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck, "Statement"], []),
	}
}

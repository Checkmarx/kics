package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	resourceType := pl[r]
	some document in input.document
	resource := document.resource[resourceType][name]

	tf_lib.allows_action_from_all_principals(resource.policy, "list")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("%s[%s].policy", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' should not be a 'List' action when 'policy.Statement.Principal' contains '*'",
		"keyActualValue": "'policy.Statement.Action' is a 'List' action when 'policy.Statement.Principal' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "policy"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	module := document.module[name]
	resourceValue := pl[r]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, resourceValue, "policy")

	tf_lib.allows_action_from_all_principals(module[keyToCheck], "list")

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' should not be a 'List' action when 'policy.Statement.Principal' contains '*'",
		"keyActualValue": "'policy.Statement.Action' is a 'List' action when 'policy.Statement.Principal' contains '*'",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

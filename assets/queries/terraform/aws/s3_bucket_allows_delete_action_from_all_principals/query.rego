package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	resourceType := pl[r]
	resource := input.document[i].resource[resourceType][name]

	tf_lib.allows_action_from_all_principals(resource.policy, "delete")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("%s[%s].policy", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Action should not be a 'Delete' action", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].policy.Action is a 'Delete' action", [resourceType, name]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	resourceType := pl[r]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, resourceType, "policy")

	tf_lib.allows_action_from_all_principals(module[keyToCheck], "delete")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' should not be a 'Delete' action",
		"keyActualValue": "'policy.Statement.Action' is a 'Delete' action",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

CxPolicy[result] {
	resourceType := pl[r]
	resource := input.document[i].resource[resourceType][name]

	tf_lib.allows_all_s3_actions_from_all_principals_match(resource.policy)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("%s[%s].policy", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Action should not be a 'Delete' action", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].policy.Action is a 'Delete' action", [resourceType, name]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	resourceType := pl[r]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, resourceType, "policy")

	tf_lib.allows_all_s3_actions_from_all_principals_match(module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' should not be a 'Delete' action",
		"keyActualValue": "'policy.Statement.Action' is a 'Delete' action",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

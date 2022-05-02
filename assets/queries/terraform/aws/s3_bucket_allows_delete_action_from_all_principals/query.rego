package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	resourceType := pl[r]
	resource := input.document[i].resource[resourceType][name]

	terra_lib.allows_action_from_all_principals(resource.policy, "delete")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Action is not a 'Delete' action", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].policy.Action is a 'Delete' action", [resourceType, name]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	resourceType := pl[r]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, resourceType, "policy")

	terra_lib.allows_action_from_all_principals(module[keyToCheck], "delete")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' is not a 'Delete' action",
		"keyActualValue": "'policy.Statement.Action' is a 'Delete' action",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

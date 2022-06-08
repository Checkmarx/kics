package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	resourceValue := pl[r]
	resource := input.document[i].resource[resourceValue][name]

<<<<<<< HEAD
	terra_lib.allows_action_from_all_principals(resource.policy, "*")
=======
	tf_lib.allows_action_from_all_principals(resource.policy, "*")
>>>>>>> v1.5.10

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceValue,
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
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

<<<<<<< HEAD
	terra_lib.allows_action_from_all_principals(module[keyToCheck], "*")
=======
	tf_lib.allows_action_from_all_principals(module[keyToCheck], "*")
>>>>>>> v1.5.10

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' doesn't contain '*' when 'policy.Statement.Principal' contains '*'",
		"keyActualValue": "'policy.Statement.Action' contains '*' when 'policy.Statement.Principal' contains '*'",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

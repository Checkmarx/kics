package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	resource := input.document[i].resource[pl[r]][name]

	tf_lib.allows_action_from_all_principals(resource.policy, "write_acp")

	result := {
		"documentId": input.document[i].id,
		"resourceType": pl[r],
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("%s[%s].policy", [pl[r], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "No Action is set to 'Write_ACP'",
		"keyActualValue": "No Action is set to 'Write_ACP'",
		"searchLine": common_lib.build_search_line(["resource", pl[r], name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "policy")

	tf_lib.allows_action_from_all_principals(module[keyToCheck], "write_acp")
    

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "No Action is set to 'Write_ACP'",
		"keyActualValue": sprintf("module[%s].policy.Action is a 'Write_ACP' action", [name]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
	}
}

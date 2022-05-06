package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	resource := input.document[i].resource[pl[r]][name]
	terra_lib.allows_action_from_all_principals(resource.policy, "get")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy.Action", [pl[r], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Action is not a 'Get' action", [pl[r], name]),
		"keyActualValue": sprintf("%s[%s].policy.Action is a 'Get' action", [pl[r], name]),
		"searchLine": common_lib.build_search_line(["resource", pl[r], name, "policy", "Statement"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "policy")
	terra_lib.allows_action_from_all_principals(module[keyToCheck], "get")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].%s.Action", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].policy.Action is not a 'Get' action", [name]),
		"keyActualValue": sprintf("module[%s].policy.Action is a 'Get' action", [name]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck, "Statement"], []),
	}
}

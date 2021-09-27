package Cx

import data.generic.common as common_lib
import data.generic.terraform as terraLib

CxPolicy[result] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	resource := input.document[i].resource[pl[r]][name]

	policy := common_lib.json_unmarshal(resource.policy)
	statement := policy.Statement[idx]

	statement.Effect == "Allow"
	terraLib.anyPrincipal(statement)
	common_lib.containsOrInArrayContains(statement.Action, "write_acp")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy.Action", [pl[r], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Action is not a 'Write_ACP' action", [pl[r], name]),
		"keyActualValue": sprintf("%s[%s].policy.Action is a 'Write_ACP' action", [pl[r], name]),
		"searchLine": common_lib.build_search_line(["resource", pl[r], name, "policy", "Statement", idx, "Action"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "policy")

	policy := common_lib.json_unmarshal(module[keyToCheck])
	statement := policy.Statement[idx]

	statement.Effect == "Allow"
	terraLib.anyPrincipal(statement)
	common_lib.containsOrInArrayContains(statement.Action, "write_acp")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].policy.Action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].policy.Action is not a 'Write_ACP' action", [name]),
		"keyActualValue": sprintf("module[%s].policy.Action is a 'Write_ACP' action", [name]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck, "Statement", idx, "Action"], []),
	}
}

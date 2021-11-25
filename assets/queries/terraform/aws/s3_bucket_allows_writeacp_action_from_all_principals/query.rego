package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	resource := input.document[i].resource[pl[r]][name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	terra_lib.anyPrincipal(statement)
	common_lib.containsOrInArrayContains(statement.Action, "write_acp")

	result := {
		"documentId": input.document[i].id,
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

	policy := common_lib.json_unmarshal(module[keyToCheck])
    st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	terra_lib.anyPrincipal(statement)
	common_lib.containsOrInArrayContains(statement.Action, "write_acp")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "No Action is set to 'Write_ACP'",
		"keyActualValue": sprintf("module[%s].policy.Action is a 'Write_ACP' action", [name]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
	}
}

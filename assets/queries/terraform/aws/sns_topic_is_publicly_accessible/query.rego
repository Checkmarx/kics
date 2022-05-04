package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sns_topic[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	terra_lib.anyPrincipal(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sns_topic[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Statement.Principal.AWS' doesn't contain '*'",
		"keyActualValue": "'Statement.Principal.AWS' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_sns_topic", name, "policy"], []),
	}
}

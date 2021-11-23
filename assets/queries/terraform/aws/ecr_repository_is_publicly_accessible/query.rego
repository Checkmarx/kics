package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository_policy[name]
	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	terra_lib.anyPrincipal(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Statement.Principal' doesn't contain '*'",
		"keyActualValue": "'Statement.Principal' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_ecr_repository_policy", name, "policy"], []),
	}
}

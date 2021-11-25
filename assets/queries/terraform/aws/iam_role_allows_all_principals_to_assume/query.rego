package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	policyResource := input.document[i].resource.aws_iam_role[name].assume_role_policy

	policy := common_lib.json_unmarshal(policyResource)

	st := common_lib.get_statement(policy)
	statement := st[_]
	aws := statement.Principal.AWS

	common_lib.is_allow_effect(statement)
	common_lib.allowsAllPrincipalsToAssume(aws, statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'assume_role_policy.Statement.Principal.AWS' does not contain ':root'",
		"keyActualValue": "'assume_role_policy.Statement.Principal.AWS' contains ':root'",
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_role", name, "assume_role_policy", "Principal", "AWS"], []),
	}
}

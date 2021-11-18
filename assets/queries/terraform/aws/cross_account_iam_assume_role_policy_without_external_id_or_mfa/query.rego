package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]

	policy := common_lib.json_unmarshal(resource.assume_role_policy)

	statement := common_lib.get_statement(policy)

	statement.Effect == "Allow"

	common_lib.is_cross_account(statement)
	common_lib.is_assume_role(statement)

	not common_lib.has_externalID(statement)
	not common_lib.has_mfa(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'assume_role_policy' requires external ID or MFA",
		"keyActualValue": "'assume_role_policy' does not require external ID or MFA",
		"searchLine": common_lib.build_search_line(["resource", "aws_redshift_cluster", name], []),
	}
}


package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]

	policy := common_lib.json_unmarshal(resource.assume_role_policy)

	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)

	common_lib.is_cross_account(statement)
	common_lib.is_assume_role(statement)

	not common_lib.has_external_id(statement)
	not common_lib.has_mfa(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_role",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'assume_role_policy' requires external ID or MFA",
		"keyActualValue": "'assume_role_policy' does not require external ID or MFA",
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_role", name, "assume_role_policy"], []),
	}
}


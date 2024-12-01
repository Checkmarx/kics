package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_iam_role[name]
	policyResource := resource.assume_role_policy

	policy := common_lib.json_unmarshal(policyResource)

	st := common_lib.get_statement(policy)
	some statement in st
	aws := statement.Principal.AWS

	common_lib.is_allow_effect(statement)
	common_lib.allowsAllPrincipalsToAssume(aws, statement)

	result := {
		"documentId": document.id,
		"resourceType": "aws_iam_role",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'assume_role_policy.Statement.Principal.AWS' should not contain ':root'",
		"keyActualValue": "'assume_role_policy.Statement.Principal.AWS' contains ':root'",
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_role", name, "assume_role_policy", "Principal", "AWS"], []),
	}
}

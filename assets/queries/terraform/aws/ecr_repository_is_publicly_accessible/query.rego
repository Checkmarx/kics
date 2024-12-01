package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_ecr_repository_policy[name]
	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	some statement in st

	common_lib.is_allow_effect(statement)
	tf_lib.anyPrincipal(statement)

	result := {
		"documentId": document.id,
		"resourceType": "aws_ecr_repository_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecr_repository_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Statement.Principal' shouldn't contain '*'",
		"keyActualValue": "'Statement.Principal' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_ecr_repository_policy", name, "policy"], []),
	}
}

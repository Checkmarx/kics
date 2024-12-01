package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_ssoadmin_permission_set_inline_policy[name]

	policy := common_lib.json_unmarshal(resource.inline_policy)
	st := common_lib.get_statement(policy)
	some statement in st

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Resource, "*")
	common_lib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_ssoadmin_permission_set_inline_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ssoadmin_permission_set_inline_policy[%s].inline_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "inline_policy.Statement.Action should not equal to, nor contain '*'",
		"keyActualValue": "inline_policy.Statement.Action is equal to or contains '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssoadmin_permission_set_inline_policy", name, "inline_policy"], []),
	}
}

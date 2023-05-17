package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resourceType := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy", "aws_ssoadmin_permission_set_inline_policy", "aws_ssoadmin_permission_set"}
	resource := input.document[i].resource[resourceType[idx]][name]

	policy := common_lib.json_unmarshal(resource.policy)

	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Resource, "*")
	common_lib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].policy", [resourceType[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' shouldn't contain '*'",
		"keyActualValue": "'policy.Statement.Action' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", resourceType[idx], name, "policy"], []),
	}
}

CxPolicy[result] {
	resourceType := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy", "aws_ssoadmin_permission_set_inline_policy", "aws_ssoadmin_permission_set"}
	resource := input.document[i].resource[resourceType[idx]][name]

	inline_policy := common_lib.json_unmarshal(resource.inline_policy)

	st := common_lib.get_statement(inline_policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Resource, "*")
	common_lib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].inline_policy", [resourceType[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'inline_policy.Statement.Action' shouldn't contain '*'",
		"keyActualValue": "'inline_policy.Statement.Action' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", resourceType[idx], name, "policy"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].data.aws_iam_policy_document[name]

    policy := {"Statement": resource.statement}

	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.resources, "*")
	common_lib.equalsOrInArray(statement.actions, "*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy_document[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' shouldn't contain '*'",
		"keyActualValue": "'policy.Statement.Action' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_policy_document", name, "policy"], []),
	}
}

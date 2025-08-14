package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resourceType := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy"}
	resource := input.document[i].resource[resourceType[idx]][name]

	policy := common_lib.json_unmarshal(resource.policy)

	st := common_lib.get_statement(policy)
	statement := st[statement_id]

	common_lib.is_allow_effect(statement)
	is_full_priviledge_permission(statement.Action)
	common_lib.equalsOrInArray(statement.Resource, "*")

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
	resource := input.document[i].data.aws_iam_policy_document[name]
	not is_array(resource.statement)

	statement := resource.statement

	common_lib.is_allow_effect(statement)
	is_full_priviledge_permission(statement.actions)
	common_lib.equalsOrInArray(statement.resources, "*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy_document[%s].statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'statement.actions' shouldn't contain '*'",
		"keyActualValue": "'statement.actions' contains '*'",
		"searchLine": common_lib.build_search_line(["data", "aws_iam_policy_document", name, "statement"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].data.aws_iam_policy_document[name]
	is_array(resource.statement)

	statement := resource.statement[statement_index]

	common_lib.is_allow_effect(statement)
	is_full_priviledge_permission(statement.actions)
	common_lib.equalsOrInArray(statement.resources, "*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy_document[%s].statement[%s]", [name, statement_index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'statement.actions' shouldn't contain '*'",
		"keyActualValue": "'statement.actions' contains '*'",
		"searchLine": common_lib.build_search_line(["data", "aws_iam_policy_document", name, "statement", statement_index], []),
	}
}

is_full_priviledge_permission(Resource) = true {
	common_lib.equalsOrInArray(Resource, "*")
} else = true {
	common_lib.equalsOrInArray(Resource, "iam:*")
} else = false

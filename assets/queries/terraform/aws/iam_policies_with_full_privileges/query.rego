package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	resourceType := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy"}
	some document in input.document
	resource := document.resource[resourceType[idx]][name]

	policy := common_lib.json_unmarshal(resource.policy)

	st := common_lib.get_statement(policy)
	some statement in st

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Resource, "*")
	common_lib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": document.id,
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
	some document in input.document
	resource := document.data.aws_iam_policy_document[name]

	policy := {"Statement": resource.statement}

	st := common_lib.get_statement(policy)
	some statement in st

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.resources, "*")
	common_lib.equalsOrInArray(statement.actions, "*")

	result := {
		"documentId": document.id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy_document[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' shouldn't contain '*'",
		"keyActualValue": "'policy.Statement.Action' contains '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_policy_document", name, "policy"], []),
	}
}

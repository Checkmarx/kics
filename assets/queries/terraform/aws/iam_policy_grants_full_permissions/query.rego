package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resourceType := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy"}
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
		"keyExpectedValue": "'policy.Statement.Resource' and 'policy.Statement.Action' should not equal '*'",
		"keyActualValue": "'policy.Statement.Resource' and 'policy.Statement.Action' are equal to '*'",
		"searchLine": common_lib.build_search_line(["resource", resourceType[idx], name, "policy"], []),
	}
}

CxPolicy[result] {
	data_res := input.document[i].data.aws_iam_policy_document[name]

	statement := data_res.statement

	common_lib.is_allow_effect(statement)
	common_lib.containsOrInArrayContains(statement.resources, "*")
	common_lib.containsOrInArrayContains(statement.actions, "*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": name,
		"searchKey": sprintf("aws_iam_policy_document[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'statement.resources' and 'statement.actions' should not contain '*'",
		"keyActualValue": "'statement.resources' and 'statement.actions' contain '*'",
		"searchLine": common_lib.build_search_line(["data", "aws_iam_policy_document", name], []),
	}
}


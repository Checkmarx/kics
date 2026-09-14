package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# aws_iam_role with inline JSON assume_role_policy: no sub condition
CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]
	policy := common_lib.get_policy(resource.assume_role_policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	statement.Action == "sts:AssumeRoleWithWebIdentity"
	statement.Principal.Federated
	not has_sub_condition_json(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_role",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_iam_role[%s].assume_role_policy should have a condition restricting the OIDC 'sub' claim", [name]),
		"keyActualValue": sprintf("aws_iam_role[%s].assume_role_policy has no 'sub' condition, allowing any identity from the OIDC provider to assume the role", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_role", name, "assume_role_policy"], []),
	}
}

# aws_iam_role, action as array (e.g. "Actions": ["sts:AssumeRoleWithWebIdentity"])
CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]
	policy := common_lib.get_policy(resource.assume_role_policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	statement.Action[_] == "sts:AssumeRoleWithWebIdentity"
	statement.Principal.Federated
	not has_sub_condition_json(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_role",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_iam_role[%s].assume_role_policy should have a condition restricting the OIDC 'sub' claim", [name]),
		"keyActualValue": sprintf("aws_iam_role[%s].assume_role_policy has no 'sub' condition, allowing any identity from the OIDC provider to assume the role", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_role", name, "assume_role_policy"], []),
	}
}

# aws_iam_policy_document (single statement): no sub condition
CxPolicy[result] {
	resource := input.document[i].data.aws_iam_policy_document[name]
	not is_array(resource.statement)
	statement := resource.statement

	common_lib.is_allow_effect(statement)
	statement.actions[_] == "sts:AssumeRoleWithWebIdentity"
	lower(statement.principals.type) == "federated"
	not has_sub_condition_hcl(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy_document[%s].statement", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_iam_policy_document[%s].statement should have a condition restricting the OIDC 'sub' claim", [name]),
		"keyActualValue": sprintf("aws_iam_policy_document[%s].statement has no 'sub' condition, allowing any identity from the OIDC provider to assume the role", [name]),
		"searchLine": common_lib.build_search_line(["data", "aws_iam_policy_document", name, "statement"], []),
	}
}

# aws_iam_policy_document (array of statements): no sub condition
CxPolicy[result] {
	resource := input.document[i].data.aws_iam_policy_document[name]
	is_array(resource.statement)
	statement := resource.statement[_]

	common_lib.is_allow_effect(statement)
	statement.actions[_] == "sts:AssumeRoleWithWebIdentity"
	lower(statement.principals.type) == "federated"
	not has_sub_condition_hcl(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy_document[%s].statement", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_iam_policy_document[%s].statement should have a condition restricting the OIDC 'sub' claim", [name]),
		"keyActualValue": sprintf("aws_iam_policy_document[%s].statement has no 'sub' condition, allowing any identity from the OIDC provider to assume the role", [name]),
		"searchLine": common_lib.build_search_line(["data", "aws_iam_policy_document", name, "statement"], []),
	}
}

# sub condition exists in inline JSON Condition block
has_sub_condition_json(statement) {
	statement.Condition[_][key]
	endswith(key, ":sub")
}

has_sub_condition_json(statement) {
	statement.condition[_][key]
	endswith(key, ":sub")
}

# sub condition exists in HCL aws_iam_policy_document condition block
has_sub_condition_hcl(statement) {
	not is_array(statement.condition)
	endswith(statement.condition.variable, ":sub")
}

has_sub_condition_hcl(statement) {
	is_array(statement.condition)
	endswith(statement.condition[_].variable, ":sub")
}

package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# aws_iam_role inline JSON: StringLike with loose wildcard sub condition (string action)
CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]
	policy := common_lib.get_policy(resource.assume_role_policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	statement.Action == "sts:AssumeRoleWithWebIdentity"
	statement.Principal.Federated
	has_loose_wildcard_sub_json(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_role",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_iam_role[%s].assume_role_policy 'sub' condition should restrict access to a specific repository or project", [name]),
		"keyActualValue": sprintf("aws_iam_role[%s].assume_role_policy 'sub' condition uses a wildcard that allows any repository or project to assume the role", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_role", name, "assume_role_policy"], []),
	}
}

# aws_iam_role inline JSON: StringLike with loose wildcard sub condition (array action)
CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]
	policy := common_lib.get_policy(resource.assume_role_policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	statement.Action[_] == "sts:AssumeRoleWithWebIdentity"
	statement.Principal.Federated
	has_loose_wildcard_sub_json(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_role",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_iam_role[%s].assume_role_policy 'sub' condition should restrict access to a specific repository or project", [name]),
		"keyActualValue": sprintf("aws_iam_role[%s].assume_role_policy 'sub' condition uses a wildcard that allows any repository or project to assume the role", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_role", name, "assume_role_policy"], []),
	}
}

# aws_iam_policy_document (single statement): loose wildcard sub condition
CxPolicy[result] {
	resource := input.document[i].data.aws_iam_policy_document[name]
	not is_array(resource.statement)
	statement := resource.statement

	common_lib.is_allow_effect(statement)
	statement.actions[_] == "sts:AssumeRoleWithWebIdentity"
	lower(statement.principals.type) == "federated"
	has_loose_wildcard_sub_hcl(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy_document[%s].statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_iam_policy_document[%s].statement 'sub' condition should restrict access to a specific repository or project", [name]),
		"keyActualValue": sprintf("aws_iam_policy_document[%s].statement 'sub' condition uses a wildcard that allows any repository or project to assume the role", [name]),
		"searchLine": common_lib.build_search_line(["data", "aws_iam_policy_document", name, "statement"], []),
	}
}

# aws_iam_policy_document (array of statements): loose wildcard sub condition
CxPolicy[result] {
	resource := input.document[i].data.aws_iam_policy_document[name]
	is_array(resource.statement)
	statement := resource.statement[_]

	common_lib.is_allow_effect(statement)
	statement.actions[_] == "sts:AssumeRoleWithWebIdentity"
	lower(statement.principals.type) == "federated"
	has_loose_wildcard_sub_hcl(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy_document[%s].statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_iam_policy_document[%s].statement 'sub' condition should restrict access to a specific repository or project", [name]),
		"keyActualValue": sprintf("aws_iam_policy_document[%s].statement 'sub' condition uses a wildcard that allows any repository or project to assume the role", [name]),
		"searchLine": common_lib.build_search_line(["data", "aws_iam_policy_document", name, "statement"], []),
	}
}

# Detect loose wildcard sub in inline JSON:
# StringLike operator with a sub key where the value is "*" or starts with "prefix:*"
has_loose_wildcard_sub_json(statement) {
	value := statement.Condition.StringLike[key]
	endswith(key, ":sub")
	is_loose_sub_value(value)
}

has_loose_wildcard_sub_json(statement) {
	value := statement.Condition.StringLike[key][_]
	endswith(key, ":sub")
	is_loose_sub_value(value)
}

# Detect loose wildcard sub in HCL:
# condition block with test=StringLike and variable ending in :sub, and a loose value
has_loose_wildcard_sub_hcl(statement) {
	not is_array(statement.condition)
	lower(statement.condition.test) == "stringlike"
	endswith(statement.condition.variable, ":sub")
	value := statement.condition.values[_]
	is_loose_sub_value(value)
}

has_loose_wildcard_sub_hcl(statement) {
	is_array(statement.condition)
	cond := statement.condition[_]
	lower(cond.test) == "stringlike"
	endswith(cond.variable, ":sub")
	value := cond.values[_]
	is_loose_sub_value(value)
}

# A sub value is too broad if:
# - it is exactly "*" (matches all)
# - it matches "prefix:*" where the first path segment after the provider prefix is a wildcard
#   e.g. "repo:*", "project_path:*:ref_type:..."
is_loose_sub_value(value) {
	value == "*"
}

is_loose_sub_value(value) {
	regex.match(`^[^:]+:\*`, value)
}

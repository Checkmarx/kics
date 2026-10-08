package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Case of "aws_iam_role" without an allow-listing 'sub' condition
CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]
	policy := common_lib.get_policy(resource.assume_role_policy)
	statement := common_lib.get_statement(policy)[_]

	is_oidc_trust(statement)
	not has_allow_listing_sub(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_role",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_iam_role[%s].assume_role_policy should have a condition restricting the OIDC 'sub' claim to an allow-list (e.g. StringEquals)", [name]),
		"keyActualValue": sprintf("aws_iam_role[%s].assume_role_policy has no allow-listing condition on the OIDC 'sub' claim, allowing any identity from the OIDC provider to assume the role", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_role", name, "assume_role_policy"], []),
	}
}

# Case of "aws_iam_policy_document" without an allow-listing 'sub' condition
CxPolicy[result] {
	resource := input.document[i].data.aws_iam_policy_document[name]
	statement := common_lib.get_statement(resource)[_]

	is_oidc_trust(statement)
	not has_allow_listing_sub(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy_document[%s].statement", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_iam_policy_document[%s].statement should have a condition restricting the OIDC 'sub' claim to an allow-list (e.g. StringEquals)", [name]),
		"keyActualValue": sprintf("aws_iam_policy_document[%s].statement has no allow-listing condition on the OIDC 'sub' claim, allowing any identity from the OIDC provider to assume the role", [name]),
		"searchLine": common_lib.build_search_line(["data", "aws_iam_policy_document", name, "statement"], []),
	}
}

# Case of "aws_iam_role" with a wildcard 'sub' condition
CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]
	policy := common_lib.get_policy(resource.assume_role_policy)
	statement := common_lib.get_statement(policy)[_]

	is_oidc_trust(statement)
	has_wildcard_sub(statement)
	not has_restrictive_sub(statement)

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

# Case of "aws_iam_policy_document" with a wildcard 'sub' condition
CxPolicy[result] {
	resource := input.document[i].data.aws_iam_policy_document[name]
	statement := common_lib.get_statement(resource)[_]

	is_oidc_trust(statement)
	has_wildcard_sub(statement)
	not has_restrictive_sub(statement)

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

# Checks if an Allow statement lets a federated (OIDC) principal call sts:AssumeRoleWithWebIdentity
is_oidc_trust(statement) {
	common_lib.is_allow_effect(statement)
	is_web_identity_action(statement)
	is_federated_principal(statement)
}

# Checks if the action (string or list, case-insensitive) is sts:AssumeRoleWithWebIdentity
is_web_identity_action(statement) {
	action := as_list(tf_lib.get_action(statement))[_]
	lower(action) == "sts:assumerolewithwebidentity"
}

# JSON policy
is_federated_principal(statement) {
	statement.Principal.Federated
}

# HCL policy document, one or several "principals" blocks
is_federated_principal(statement) {
	lower(as_list(statement.principals)[_].type) == "federated"
}

# Gets the 'sub' conditions as {test, values}, from the HCL "condition" block(s) or from the JSON "Condition"
sub_conditions(statement) = conds {
	cond := tf_lib.get_condition(statement)
	hcl := {{"test": lower(c.test), "values": c.values} | c := as_list(cond)[_]; endswith(c.variable, ":sub")}
	json := {{"test": lower(op), "values": cond[op][key]} | is_object(cond[op]); endswith(key, ":sub")}
	conds := hcl | json
}

# Checks if the operator compares 'sub' against an allow-list (string operator that is not negated)
# "Not" operators and other families (e.g. Null) do not restrict who can assume the role
is_allow_listing(cond) {
	contains(cond.test, "string")
	not contains(cond.test, "not")
}

# Checks if a "StringLike" operator has a loose 'sub' value (with "StringEquals" the wildcard is a literal)
is_wildcard(cond) {
	contains(cond.test, "stringlike")
	is_loose_sub_value(as_list(cond.values)[_])
}

has_allow_listing_sub(statement) {
	is_allow_listing(sub_conditions(statement)[_])
}

has_wildcard_sub(statement) {
	is_wildcard(sub_conditions(statement)[_])
}

# Checks if an allow-listing 'sub' condition without wildcard exists (conditions are ANDed)
has_restrictive_sub(statement) {
	cond := sub_conditions(statement)[_]
	is_allow_listing(cond)
	not is_wildcard(cond)
}

# Wraps a single value in a list
as_list(values) = list {
	is_array(values)
	list := values
} else = list {
	list := [values]
}

# Checks if the identity segment of the 'sub' value is a wildcard, e.g. "*", "repo:*" or "project_path:*:..."
is_loose_sub_value(value) {
	regex.match(`^([^:]+:)?[*?]`, value)
}

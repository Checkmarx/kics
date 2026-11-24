package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	policy := common_lib.get_policy(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	not common_lib.valid_key(statement, "Condition")
	common_lib.has_wildcard(statement, "kms:*")
	not account_root_only(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_kms_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_kms_key[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_kms_key[%s].policy should not have wildcard in 'Action' and 'Principal'", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].policy has wildcard in 'Action' or 'Principal'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_kms_key", name, "policy"], []),
	}
}

# kms:* on the account root enables IAM delegation. It does not grant other principals.
account_root_only(statement) {
	principals := aws_principals(statement)
	count(principals) > 0
	count({p | p := principals[_]; not root_arn(p)}) == 0
}

aws_principals(statement) = out {
	is_string(statement.Principal.AWS)
	out := [statement.Principal.AWS]
} else = out {
	is_array(statement.Principal.AWS)
	out := statement.Principal.AWS
} else = out {
	is_string(statement.Principal)
	out := [statement.Principal]
}

root_arn(principal) {
	regex.match(`^arn:aws(-[a-z0-9]+)?:iam::[0-9]{12}:root$`, principal)
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	not common_lib.valid_key(resource, "policy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_kms_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_kms_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_kms_key[%s].policy should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].policy is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_kms_key", name], []),
	}
}


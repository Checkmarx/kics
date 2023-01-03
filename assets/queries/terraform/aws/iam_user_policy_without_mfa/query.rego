package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_user_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	statement.Action == "sts:AssumeRole"
	common_lib.is_allow_effect(statement)
	check_root(statement, resource)
	not check_mfa(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_user_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_user_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Principal.AWS' should contain ':mfa/' or 'policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent' should be set to true",
		"keyActualValue": "'policy.Statement.Principal.AWS' doesn't contain ':mfa/' or 'policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_user_policy", name, "policy"], []),
	}
}

check_mfa(statement) {
	statement.Condition.BoolIfExists["aws:MultiFactorAuthPresent"] == "true"
} else {
	user := statement.Principal.AWS
	contains(user, ":mfa/")
} else {
	user := statement.Principal.AWS[_]
	contains(user, ":mfa/")
}

check_root(statement, resource) {
	user := statement.Principal.AWS
	contains(user, "root")
} else {
	user := statement.Principal.AWS[_]
	contains(user, "root")
} else {
	tf_lib.anyPrincipal(statement)
} else {
	options := {"user", "name"}
	contains(resource[options[_]], "root")
}

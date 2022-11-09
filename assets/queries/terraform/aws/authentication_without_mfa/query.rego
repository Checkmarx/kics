package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_iam_user_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	not_exists_mfa(statement) == "undefined"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_user_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_user_policy[%s].policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attributes 'policy.Statement.Condition', 'policy.Statement.Condition.BoolIfExists', and 'policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent' should be defined and not null",
		"keyActualValue": "The attribute(s) 'policy.Statement.Condition' or/and 'policy.Statement.Condition.BoolIfExists' or/and 'policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent' is/are undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_user_policy", name, "policy"], []),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_iam_user_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	not_exists_mfa(statement) == "false"

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


not_exists_mfa(statement) = mfa {
	not common_lib.valid_key(statement.Condition.BoolIfExists, "aws:MultiFactorAuthPresent")

	mfa := "undefined"
} else = mfa {
	not common_lib.valid_key(statement.Condition, "BoolIfExists")

	mfa := "undefined"
} else = mfa {
	not common_lib.valid_key(statement, "Condition")

	mfa := "undefined"
} else = mfa {
	statement.Condition.BoolIfExists["aws:MultiFactorAuthPresent"] != "true"
	mfa := "false"
} else = mfa {
	user := statement.Principal.AWS
	not contains(user, ":mfa/")
	mfa := "false"
} else = mfa {
	user := statement.Principal.AWS[_]
	not contains(user, ":mfa/")
	mfa := "false"
}


package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_iam_user_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	statement := policy.Statement

	mfa := existsMFA(statement)
	mfa == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.aws_iam_user_policy[%s].policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'aws:MultiFactorAuthPresent' is set",
		"keyActualValue": "Attribute 'aws:MultiFactorAuthPresent' is undefined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_iam_user_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	statement := policy.Statement

	mfa := existsMFA(statement)
	mfa == "false"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.aws_iam_user_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'aws:MultiFactorAuthPresent' is set a true",
		"keyActualValue": "Attribute 'aws:MultiFactorAuthPresent' is set a false",
	}
}

existsMFA(statement) = mfa {
	isArray := is_array(statement)
	b := statement[index].Condition.BoolIfExists

	not common_lib.valid_key(b, "aws:MultiFactorAuthPresent")

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isArray := is_array(statement)
	c := statement[index].Condition

	not common_lib.valid_key(c, "BoolIfExists")

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isArray := is_array(statement)
	s := statement[index]

	not common_lib.valid_key(s, "Condition")

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isObject := is_object(statement)

	not common_lib.valid_key(statement.Condition.BoolIfExists, "aws:MultiFactorAuthPresent")

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isObject := is_object(statement)

	not common_lib.valid_key(statement.Condition, "BoolIfExists")

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isObject := is_object(statement)

	not common_lib.valid_key(statement, "Condition")

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isObject := is_object(statement)

	common_lib.valid_key(statement.Condition.BoolIfExists, "aws:MultiFactorAuthPresent")

	mfa := statement.Condition.BoolIfExists["aws:MultiFactorAuthPresent"]
}

existsMFA(statement) = mfa {
	isArray := is_array(statement)

	common_lib.valid_key(statement[index].Condition.BoolIfExists, "aws:MultiFactorAuthPresent")

	mfa := statement[index].Condition.BoolIfExists["aws:MultiFactorAuthPresent"]
}

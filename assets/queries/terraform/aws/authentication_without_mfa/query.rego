package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_user_policy[name]

	poli := resource.policy
	output := json.unmarshal(poli)

	statement := output.Statement

	checkShortTermCredentials(input.document)

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
	resource := input.document[i].resource.aws_iam_user_policy[name]

	poli := resource.policy
	output := json.unmarshal(poli)

	statement := output.Statement

	checkShortTermCredentials(input.document)

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

	object.get(statement[index].Condition.BoolIfExists, "aws:MultiFactorAuthPresent", "undefined") == "undefined"

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isArray := is_array(statement)

	object.get(statement[index].Condition, "BoolIfExists", "undefined") == "undefined"

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isArray := is_array(statement)

	object.get(statement[index], "Condition", "undefined") == "undefined"

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isObject := is_object(statement)

	object.get(statement.Condition.BoolIfExists, "aws:MultiFactorAuthPresent", "undefined") == "undefined"

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isObject := is_object(statement)

	object.get(statement.Condition, "BoolIfExists", "undefined") == "undefined"

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isObject := is_object(statement)

	object.get(statement, "Condition", "undefined") == "undefined"

	mfa := "undefined"
}

existsMFA(statement) = mfa {
	isObject := is_object(statement)

	object.get(statement.Condition.BoolIfExists, "aws:MultiFactorAuthPresent", "undefined") != "undefined"

	mfa := statement.Condition.BoolIfExists["aws:MultiFactorAuthPresent"]
}

existsMFA(statement) = mfa {
	isArray := is_array(statement)

	object.get(statement[index].Condition.BoolIfExists, "aws:MultiFactorAuthPresent", "undefined") != "undefined"

	mfa := statement[index].Condition.BoolIfExists["aws:MultiFactorAuthPresent"]
}

checkShortTermCredentials(documents) = allow {
	resource := documents[x].provider.aws

	resource.token

	allow = true
}

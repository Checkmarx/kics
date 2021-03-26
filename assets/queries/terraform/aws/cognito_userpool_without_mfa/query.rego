package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cognito_user_pool[name]

	object.get(resource, "mfa_configuration", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_cognito_user_pool[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cognito_user_pool[%s].mfa_configuration is set", [name]),
		"keyActualValue": sprintf("aws_cognito_user_pool[%s].mfa_configuration is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cognito_user_pool[name]

	not hasValidConfig(["ON", "OPTIONAL"], resource.mfa_configuration)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_cognito_user_pool[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cognito_user_pool[%s].mfa_configuration is set to 'ON' or 'OPTIONAL", [name]),
		"keyActualValue": sprintf("aws_cognito_user_pool[%s].mfa_configuration is set to '%s'", [name, resource.mfa_configuration]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cognito_user_pool[name]

	hasValidConfig(["ON", "OPTIONAL"], resource.mfa_configuration)
	not hasRemainingConfiguration(resource)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_cognito_user_pool[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cognito_user_pool[%s] has 'sms_configuration' or 'software_token_mfa_configuration' defined", [name]),
		"keyActualValue": sprintf("aws_cognito_user_pool[%s] doesn't have 'sms_configuration' or 'software_token_mfa_configuration' defined", [name]),
	}
}

hasValidConfig(array, elem) {
	array[_] == elem
} else = false {
	true
}

hasRemainingConfiguration(resource) {
	resource.sms_configuration
}

hasRemainingConfiguration(resource) {
	resource.software_token_mfa_configuration
}

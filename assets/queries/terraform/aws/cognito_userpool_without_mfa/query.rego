package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cognito_user_pool[name]

	not common_lib.valid_key(resource, "mfa_configuration")

	result := {
		"documentId": document.id,
		"resourceType": "aws_cognito_user_pool",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cognito_user_pool[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cognito_user_pool[%s].mfa_configuration should be set", [name]),
		"keyActualValue": sprintf("aws_cognito_user_pool[%s].mfa_configuration is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cognito_user_pool[name]

	not common_lib.inArray(["ON", "OPTIONAL"], resource.mfa_configuration)

	result := {
		"documentId": document.id,
		"resourceType": "aws_cognito_user_pool",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cognito_user_pool[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cognito_user_pool[%s].mfa_configuration should be set to 'ON' or 'OPTIONAL", [name]),
		"keyActualValue": sprintf("aws_cognito_user_pool[%s].mfa_configuration is set to '%s'", [name, resource.mfa_configuration]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cognito_user_pool[name]

	common_lib.inArray(["ON", "OPTIONAL"], resource.mfa_configuration)
	not hasRemainingConfiguration(resource)

	result := {
		"documentId": document.id,
		"resourceType": "aws_cognito_user_pool",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cognito_user_pool[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cognito_user_pool[%s] should have 'sms_configuration' or 'software_token_mfa_configuration' defined", [name]),
		"keyActualValue": sprintf("aws_cognito_user_pool[%s] doesn't have 'sms_configuration' or 'software_token_mfa_configuration' defined", [name]),
	}
}

hasRemainingConfiguration(resource) {
	resource.sms_configuration
}

hasRemainingConfiguration(resource) {
	resource.software_token_mfa_configuration
}

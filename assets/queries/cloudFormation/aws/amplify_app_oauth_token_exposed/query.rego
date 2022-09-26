package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::Amplify::App"

	properties := resource.Properties
	paramName := properties.OauthToken

	defaultToken := document.Parameters[paramName].Default

	regex.match(`[A-Za-z0-9\-\._~\+\/]+=*`, defaultToken)
	not cf_lib.hasSecretManager(defaultToken, document.Resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("Parameters.%s.Default", [paramName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Parameters.%s.Default should be defined", [paramName]),
		"keyActualValue": sprintf("Parameters.%s.Default shouldn't be defined", [paramName]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::Amplify::App"

	properties := resource.Properties
	paramName := properties.OauthToken
	count(paramName) >= 50
	defaultToken := paramName
	common_lib.valid_key(document, "Parameters")
	not common_lib.valid_key(document.Parameters, paramName)

	regex.match(`[A-Za-z0-9\-\._~\+\/]+=*`, defaultToken)
	not cf_lib.hasSecretManager(defaultToken, document.Resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.BasicAuthConfig.Password", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.BasicAuthConfig.Password must not be in plain text string", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.BasicAuthConfig.Password must be defined as a parameter or have a secret manager referenced", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::Amplify::App"

	properties := resource.Properties
	paramName := properties.OauthToken
	not common_lib.valid_key(document, "Parameters")
	count(paramName) >= 50
	defaultToken := paramName

	regex.match(`[A-Za-z0-9\-\._~\+\/]+=*`, defaultToken)
	not cf_lib.hasSecretManager(defaultToken, document.Resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.BasicAuthConfig.Password", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.BasicAuthConfig.Password must not be in plain text string", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.BasicAuthConfig.Password must be defined as a parameter or have a secret manager referenced", [key]),
	}
}

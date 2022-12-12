package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DMS::Endpoint"

	properties := resource.Properties
	paramName := properties.MongoDbSettings.Password
	defaultToken := document.Parameters[paramName].Default

	regex.match(`[A-Za-z\d@$!%*"#"?&]{8,}`, defaultToken)
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
	resource.Type == "AWS::DMS::Endpoint"

	properties := resource.Properties
	paramName := properties.MongoDbSettings.Password
	not common_lib.valid_key(document, "Parameters")

	defaultToken := paramName

	regex.match(`[A-Za-z\d@$!%*"#"?&]{8,}`, defaultToken)
	not cf_lib.hasSecretManager(defaultToken, document.Resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.MongoDbSettings.Password", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MongoDbSettings.Password must not be in plain text string", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.MongoDbSettings.Password must be defined as a parameter or have a secret manager referenced", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DMS::Endpoint"

	properties := resource.Properties
	paramName := properties.MongoDbSettings.Password
	common_lib.valid_key(document, "Parameters")
	not common_lib.valid_key(document.Parameters, paramName)

	defaultToken := paramName

	regex.match(`[A-Za-z\d@$!%*"#"?&]{8,}`, defaultToken)
	not cf_lib.hasSecretManager(defaultToken, document.Resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.MongoDbSettings.Password", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MongoDbSettings.Password must not be in plain text string", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.MongoDbSettings.Password must be defined as a parameter or have a secret manager referenced", [key]),
	}
}

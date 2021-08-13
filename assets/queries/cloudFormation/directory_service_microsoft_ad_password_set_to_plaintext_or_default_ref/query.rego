package Cx

import data.generic.cloudformation as cloudFormationLib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DirectoryService::MicrosoftAD"

	properties := resource.Properties
	paramName := properties.Password
	defaultToken := document.Parameters[paramName].Default

	regex.match(`[A-Za-z\d@$!%*"#"?&]{8,}`, defaultToken)
	not cloudFormationLib.hasSecretManager(defaultToken, document.Resources)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Parameters.%s.Default", [paramName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Parameters.%s.Default isn't defined", [paramName]),
		"keyActualValue": sprintf("Parameters.%s.Default is defined", [paramName]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DirectoryService::MicrosoftAD"

	properties := resource.Properties
	paramName := properties.Password
	not common_lib.valid_key(document, "Parameters")

	defaultToken := paramName

	regex.match(`[A-Za-z\d@$!%*"#"?&]{8,}`, defaultToken)
	not cloudFormationLib.hasSecretManager(defaultToken, document.Resources)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Password", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Password must be defined as a parameter or have a secret manager referenced", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.Password must not be in plain text string", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DirectoryService::MicrosoftAD"

	properties := resource.Properties
	paramName := properties.Password
	common_lib.valid_key(document, "Parameters")
	not common_lib.valid_key(document.Parameters, paramName)

	defaultToken := paramName

	regex.match(`[A-Za-z\d@$!%*"#"?&]{8,}`, defaultToken)
	not cloudFormationLib.hasSecretManager(defaultToken, document.Resources)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Password", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Password must be defined as a parameter or have a secret manager referenced", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.Password must not be in plain text string", [key]),
	}
}

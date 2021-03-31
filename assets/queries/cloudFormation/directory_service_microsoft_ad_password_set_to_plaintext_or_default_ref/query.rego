package Cx

import data.generic.cloudformation as cloudFormationLib

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
	object.get(document, "Parameters", "undefined") == "undefined"

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
	object.get(document, "Parameters", "undefined") != "undefined"
	object.get(document.Parameters, paramName, "undefined") == "undefined"

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

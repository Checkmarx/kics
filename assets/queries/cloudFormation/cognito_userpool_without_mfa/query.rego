package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Cognito::UserPool"

	object.get(resource.Properties, "MfaConfiguration", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MfaConfiguration is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MfaConfiguration is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Cognito::UserPool"

	properties := resource.Properties
	properties.MfaConfiguration == "OFF"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.MfaConfiguration", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MfaConfiguration is set to ON or OPTIONAL", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MfaConfiguration is set to OFF", [name]),
	}
}

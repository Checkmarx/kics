package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Cognito::UserPool"

	not common_lib.valid_key(resource.Properties, "MfaConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MfaConfiguration should be set", [name]),
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
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.MfaConfiguration", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MfaConfiguration should be set to ON or OPTIONAL", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MfaConfiguration is set to OFF", [name]),
	}
}
